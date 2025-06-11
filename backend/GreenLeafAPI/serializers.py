from rest_framework import serializers
from GreenLeafAPI import models as my_models

class PlantSerializer(serializers.ModelSerializer):
    class Meta: 
        model = my_models.PlantModel
        fields = "all"
        read_only_fields = ['created_by',]


class ObservationSerializer(serializers.ModelSerializer):
    # display full plant data on get, send plant id on post
    related_plant = PlantSerializer(read_only=True)
    related_plant_id = serializers.PrimaryKeyRelatedField(
        queryset=my_models.PlantModel.objects.all(), 
        source='related_plant',
        write_only=True,
        required=False
    )
    class Meta:
        model = my_models.ObservationModel
        fields = 'all'
        read_only_fields = ['created_by',]