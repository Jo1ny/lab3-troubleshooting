import time
from http.server import HTTPServer, BaseHTTPRequestHandler

class SlowHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        # Имитируем тяжелый расчет или зависшую базу данных
        #time.sleep(5)
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b"Response after 5 seconds")

httpd = HTTPServer(('0.0.0.0', 8000), SlowHandler)
httpd.serve_forever()