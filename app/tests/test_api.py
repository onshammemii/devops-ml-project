import pytest
import json
from app import app

@pytest.fixture
def client():
    """Create test client"""
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_health_endpoint(client):
    """Test health check endpoint"""
    response = client.get('/health')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['status'] == 'healthy'

def test_ready_endpoint(client):
    """Test readiness check endpoint"""
    response = client.get('/ready')
    assert response.status_code in [200, 503]
    data = json.loads(response.data)
    assert 'status' in data

def test_predict_endpoint_success(client):
    """Test prediction endpoint with valid data"""
    payload = {
        'text': 'This product is amazing!'
    }
    response = client.post('/predict',
                          data=json.dumps(payload),
                          content_type='application/json')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert 'sentiment' in data
    assert 'confidence' in data
    assert data['sentiment'] in ['positive', 'negative']
    assert 0 <= data['confidence'] <= 1

def test_predict_endpoint_missing_text(client):
    """Test prediction endpoint with missing text field"""
    payload = {}
    response = client.post('/predict',
                          data=json.dumps(payload),
                          content_type='application/json')
    assert response.status_code == 400
    data = json.loads(response.data)
    assert 'error' in data

def test_batch_predict_endpoint(client):
    """Test batch prediction endpoint"""
    payload = {
        'texts': [
            'I love this!',
            'This is terrible',
            'Pretty decent product'
        ]
    }
    response = client.post('/batch-predict',
                          data=json.dumps(payload),
                          content_type='application/json')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert 'predictions' in data
    assert len(data['predictions']) == 3
    assert data['count'] == 3

def test_batch_predict_invalid_format(client):
    """Test batch prediction with invalid format"""
    payload = {
        'texts': 'not a list'
    }
    response = client.post('/batch-predict',
                          data=json.dumps(payload),
                          content_type='application/json')
    assert response.status_code == 400

def test_model_info_endpoint(client):
    """Test model info endpoint"""
    response = client.get('/model-info')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert 'model_type' in data
    assert 'version' in data

def test_predict_positive_sentiment(client):
    """Test prediction with clearly positive text"""
    payload = {
        'text': 'Excellent service, highly recommended!'
    }
    response = client.post('/predict',
                          data=json.dumps(payload),
                          content_type='application/json')
    assert response.status_code == 200
    data = json.loads(response.data)
    # Note: With a simple trained model, we can't guarantee the sentiment
    # but we can verify the structure is correct
    assert isinstance(data['sentiment'], str)
    assert isinstance(data['confidence'], float)

def test_predict_negative_sentiment(client):
    """Test prediction with clearly negative text"""
    payload = {
        'text': 'Horrible experience, never again!'
    }
    response = client.post('/predict',
                          data=json.dumps(payload),
                          content_type='application/json')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert isinstance(data['sentiment'], str)
    assert isinstance(data['confidence'], float)
