from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


def test_health():
    response = client.get('/health')
    assert response.status_code == 200
    assert response.json()['status'] == 'ok'


def test_capabilities():
    response = client.get('/api/v1/capabilities')
    assert response.status_code == 200
    assert 'step' in response.json()['formats']


def test_upload_and_analyze(tmp_path, monkeypatch):
    import app.main as main
    monkeypatch.setattr(main, 'UPLOADS', tmp_path)
    response = client.post('/api/v1/files', files={'file': ('part.step', b'ISO-10303-21;')})
    assert response.status_code == 200
    file_id = response.json()['id']
    analyzed = client.post(f'/api/v1/analyze/{file_id}')
    assert analyzed.status_code == 200
    assert analyzed.json()['native_geometry'] is True
