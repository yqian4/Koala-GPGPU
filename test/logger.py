import os
import sys
from datetime import datetime

class Logger:
    def __init__(self, log_dir="logs", encoding='utf-8'):
        if not os.path.exists(log_dir):
            try:
                os.makedirs(log_dir)
            except Exception as e:
                print(f"creating log folder failed: {e}")  
                log_dir = "." 
        self.filename = os.path.join(log_dir, f"log_{datetime.now().strftime('%Y%m%d%H%M%S')}.txt")
        self.encoding = encoding

    def log(self, *messages):
        complete_message = ' '.join(str(message) for message in messages)
        with open(self.filename, "a", encoding=self.encoding) as f:
            f.write(complete_message + "\n")

logger = Logger(log_dir="test/logs")