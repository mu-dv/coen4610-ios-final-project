from http.server import BaseHTTPRequestHandler, HTTPServer
 
# HTTPRequestHandler class
class teamswiftHTTPServer_RequestHandler(BaseHTTPRequestHandler):
    
    def insertScore(self, name, score):
        f = open('highscores.txt', 'r')
        
        highscores = {}
        
        # Get highscores
        for line in f:
            tmpStr = line.split(",")
            
            if (len(tmpStr) > 1):
                tmpName = str(tmpStr[0])
                tmpScore = int(tmpStr[1])
                highscores[tmpScore] = tmpName
        f.close()
        
        # Add the new score to the dictionary
        highscores[int(score)] = name
        
        strToWrite = ""
        
        for tmpScore in sorted(highscores):
            strToWrite = strToWrite + highscores[tmpScore] + "," + str(tmpScore) + "\n"
         
        # Write back the sorted highscores
        f = open('highscores.txt', 'w')
        f.write(strToWrite)
        f.close()
        return
    
    
    def do_GET(self):
        # Send response status code
        self.send_response(200)
        
        if ('score' in self.path):
            tmpStr = self.path.split("/")
            self.insertScore(tmpStr[2], tmpStr[3])
        
        # Send headers
        self.send_header('Content-type','text/html')
        self.end_headers()
        
        # Send highscores back to client
        f = open('highscores.txt', 'r')
        
        message = f.read()
        
        # Write content as utf-8 data
        self.wfile.write(bytes(message, "utf8"))
        f.close()
        return
        
    
        
def run():
    print('starting server...')

    # Server settings
    # Choose port 8080, for port 80, which is normally used for a http server, you need root access
    # You need to modify this address manually to your IPv4 address
    server_address = ('10.160.5.65', 8081)
    httpd = HTTPServer(server_address, teamswiftHTTPServer_RequestHandler)
    print('running server...')
    httpd.serve_forever()


run()