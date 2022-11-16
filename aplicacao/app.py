import os

from api.api import api_profile
from flask import Flask

app = Flask(__name__)
app.register_blueprint(api_profile)

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 3000))
    app.run(host="0.0.0.0", threaded=True, port=port, debug=True)
