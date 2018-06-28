#!/usr/bin/python
import airflow
from airflow import models, settings
from airflow.contrib.auth.backends.password_auth import PasswordUser
user = PasswordUser(models.User())
user.username = 'test'
user.email = 'goskp@yahoo.com'
user.password = 'test_123'
session = settings.Session()
session.add(user)
session.commit()
session.close()
exit()