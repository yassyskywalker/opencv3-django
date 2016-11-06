FROM nabladesignlabs/anaconda3-ubuntu

# Install python and pip
RUN apt-get update && apt-get install -y --no-install-recommends postgresql-client python-pip build-essential libpq-dev python3-dev libgtk2.0-0
ADD requirements.txt /usr/src/app/requirements.txt

# Install dependencies
RUN pip install setuptools
RUN pip install -r /usr/src/app/requirements.txt
RUN conda install -y --channel https://conda.anaconda.org/menpo opencv3

# Add our code
ADD . /usr/src/app/
WORKDIR /usr/src/app

# Expose is NOT supported by Heroku
# EXPOSE 5000

# Run the image as a non-root user
RUN useradd -m myuser
USER myuser

# Run the app.  CMD is required to run on Heroku
# $PORT is set by Heroku
CMD gunicorn --bind 0.0.0.0:$PORT gettingstarted.wsgi