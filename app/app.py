from flask import Flask, request, jsonify
import pickle
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
import os
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)
metrics = PrometheusMetrics(app)

# Global variables for model
model = None
vectorizer = None

def load_model():
    """Load pre-trained model or train a simple one"""
    global model, vectorizer
    
    model_path = os.getenv('MODEL_PATH', '/app/models/sentiment_model.pkl')
    vectorizer_path = os.getenv('VECTORIZER_PATH', '/app/models/vectorizer.pkl')
    
    if os.path.exists(model_path) and os.path.exists(vectorizer_path):
        with open(model_path, 'rb') as f:
            model = pickle.load(f)
        with open(vectorizer_path, 'rb') as f:
            vectorizer = pickle.load(f)
        print("✓ Loaded existing model")
    else:
        # Train a simple model for demo
        train_texts = [
            "I love this product, it's amazing!",
            "This is the best thing ever",
            "Wonderful experience, highly recommend",
            "Terrible product, waste of money",
            "I hate this, very disappointing",
            "Awful service, never again"
        ]
        train_labels = [1, 1, 1, 0, 0, 0]  # 1=positive, 0=negative
        
        vectorizer = TfidfVectorizer(max_features=100)
        X = vectorizer.fit_transform(train_texts)
        
        model = MultinomialNB()
        model.fit(X, train_labels)
        
        # Save for future use
        os.makedirs('/app/models', exist_ok=True)
        with open(model_path, 'wb') as f:
            pickle.dump(model, f)
        with open(vectorizer_path, 'wb') as f:
            pickle.dump(vectorizer, f)
        print("✓ Trained and saved new model")

@app.route('/health', methods=['GET'])
def health():
    """Kubernetes liveness probe"""
    return jsonify({"status": "healthy"}), 200

@app.route('/ready', methods=['GET'])
def ready():
    """Kubernetes readiness probe"""
    if model is None or vectorizer is None:
        return jsonify({"status": "not ready", "reason": "model not loaded"}), 503
    return jsonify({"status": "ready"}), 200

@app.route('/predict', methods=['POST'])
def predict():
    """Main prediction endpoint"""
    try:
        data = request.get_json()
        
        if not data or 'text' not in data:
            return jsonify({"error": "Missing 'text' field"}), 400
        
        text = data['text']
        
        # Transform and predict
        X = vectorizer.transform([text])
        prediction = model.predict(X)[0]
        probability = model.predict_proba(X)[0]
        
        sentiment = "positive" if prediction == 1 else "negative"
        confidence = float(max(probability))
        
        return jsonify({
            "text": text,
            "sentiment": sentiment,
            "confidence": confidence,
            "model_version": os.getenv('MODEL_VERSION', '1.0.0')
        }), 200
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/batch-predict', methods=['POST'])
def batch_predict():
    """Batch prediction for multiple texts"""
    try:
        data = request.get_json()
        
        if not data or 'texts' not in data:
            return jsonify({"error": "Missing 'texts' field"}), 400
        
        texts = data['texts']
        
        if not isinstance(texts, list):
            return jsonify({"error": "'texts' must be a list"}), 400
        
        # Transform and predict
        X = vectorizer.transform(texts)
        predictions = model.predict(X)
        probabilities = model.predict_proba(X)
        
        results = []
        for i, text in enumerate(texts):
            sentiment = "positive" if predictions[i] == 1 else "negative"
            confidence = float(max(probabilities[i]))
            results.append({
                "text": text,
                "sentiment": sentiment,
                "confidence": confidence
            })
        
        return jsonify({
            "predictions": results,
            "count": len(results),
            "model_version": os.getenv('MODEL_VERSION', '1.0.0')
        }), 200
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/model-info', methods=['GET'])
def model_info():
    """Get model information"""
    return jsonify({
        "model_type": "MultinomialNB",
        "version": os.getenv('MODEL_VERSION', '1.0.0'),
        "features": vectorizer.get_feature_names_out().tolist()[:20] if vectorizer else [],
        "status": "loaded" if model else "not loaded"
    }), 200

if __name__ == '__main__':
    print("Starting Sentiment Analysis API...")
    load_model()
    port = int(os.getenv('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)
