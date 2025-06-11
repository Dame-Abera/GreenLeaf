from rest_framework.routers import DefaultRouter
from .views import PlantViewSet, ObservationViewSet

router = DefaultRouter()
router.register(r'plants', PlantViewSet, basename='plant')
router.register(r'observations', ObservationViewSet, basename='observation')

urlpatterns = router.urls
