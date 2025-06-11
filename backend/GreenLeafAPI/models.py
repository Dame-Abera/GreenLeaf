from django.db import models

# Create your models here.
from django.db import models
from django.utils.timezone import now
from django.contrib.auth import get_user_model


# upload path for plant record image
def plant_upload_to(instance, filename):
    user_id = instance.created_by.id if instance.created_by else 'unknown'
    return f'plants/{user_id}/{filename}'


class PlantModel(models.Model):
    plant_image = models.ImageField(blank=True, null=True, upload_to=plant_upload_to)
    common_name = models.CharField(max_length=255)
    scientific_name = models.CharField(max_length=255)
    habitat = models.CharField(max_length=255)
    origin = models.CharField(max_length=100, null=True, blank=True)
    description = models.CharField(max_length=3000, null=True, blank=True)
    created_by = models.ForeignKey(get_user_model(), on_delete=models.CASCADE, related_name='plants', default="no user")

    def str(self):
        return self.scientific_name


# upload path for observation record image                                            
def observation_upload_to(instance, filename):
    user_id = instance.created_by.id if instance.created_by else 'unknown'
    return f'observations/{user_id}/{filename}'


class ObservationModel(models.Model):
    observation_image = models.ImageField(null=True, blank=True, upload_to=observation_upload_to)
    related_plant = models.ForeignKey(PlantModel, on_delete=models.SET_NULL, null=True, blank=True)
    time = models.TimeField(default=now)
    date = models.DateField(default=now)
    location = models.CharField(max_length=250)
    note = models.CharField(max_length=3000, null=True, blank=True)
    created_by = models.ForeignKey(get_user_model(), on_delete=models.CASCADE, related_name='observations',default="no user")


