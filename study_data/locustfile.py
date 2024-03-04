from locust import HttpUser, task

# For Testing HPA
# Stress Test Tool (locust.io) // pip install locust
# locustfile.py (해당파일) 가 들어있는 폴더 터미널에서 locust 를 치면 web cli 가 자동으로 실행되며 url 을 던져준다
class HelloWorldUser(HttpUser):
    @task
    def hello_world(self):
        self.client.get("/liveness")
