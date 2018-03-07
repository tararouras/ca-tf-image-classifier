FROM python:2.7.13

ADD . /home/abdul/Documents/Dsgit/ca-tf-image-classifier

ADD ./requirements.txt /home/abdul/Documents/Dsgit/ca-tf-image-classifier

RUN apt-get update \
 && pip install -r /home/abdul/Documents/Dsgit/ca-tf-image-classifier/requirements.txt \
 && rm -rf /var/lib/apt/lists/*

ADD . /home/abdul/Documents/Dsgit/ca-tf-image-classifier

ENTRYPOINT [ "python", "-u", "/home/abdul/Documents/Dsgit/ca-tf-image-classifier/manage.py", "runserver", "0.0.0.0:8000"]

