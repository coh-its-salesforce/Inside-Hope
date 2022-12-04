@isTest
global class cordinatesMockCallout implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"animal": {"id":1, "name":"Tiger"}}');
        response.setStatusCode(200);
        return response;
    }
}