from django.http import HttpResponse, HttpResponseServerError

def home(request):
    return HttpResponse("Home Connection Success")

def liveness(request):
    return HttpResponse("Live Connection Success")

def readiness(request):
    try:
        # Connect to database
        return HttpResponse("Read Connection OK")
    except Exception as e:
        return HttpResponseServerError("db: cannot connect to database.")
