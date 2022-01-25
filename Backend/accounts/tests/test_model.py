from django.test import TestCase
from rest_framework.test import APITestCase
from accounts.models import User


class UserTestCase(APITestCase):
    def test_create_user(self):
        '''
        Test python manage.py createuser function
        '''
        user = User.objects.create_user(
            'user', 'user@onlink4it.com', 'P@$$w0rd!')
        self.assertIsInstance(user, User)
        self.assertFalse(user.is_staff)
        self.assertEqual(user.email, 'user@onlink4it.com')

    def test_create_superuser(self):
        '''
        Test python manage.py createuseruser function
        '''
        admin = User.objects.create_superuser(
            'admin', 'admin@onlink4it.com', 'P@$$w0rd!')
        self.assertIsInstance(admin, User)
        self.assertTrue(admin.is_staff)
        self.assertTrue(admin.is_superuser)
        self.assertEqual(admin.email, 'admin@onlink4it.com')

    def test_full_name(self):
        '''
        Test the __str__ return get the full name
        '''
        user = User.objects.create(first_name='AHMED', last_name='ELKHAYYAT',
                                   username='amk', email='amk@onlink4it.com', password='P@$$w0rd!')
        self.assertEqual(str(user), 'AHMED ELKHAYYAT')

