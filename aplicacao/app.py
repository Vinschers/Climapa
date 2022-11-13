import os

from flask import Flask

from api import db_profile

app = Flask(__name__)
app.register_blueprint(db_profile)

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 3000))
    app.run(host="0.0.0.0", threaded=True, port=port)
