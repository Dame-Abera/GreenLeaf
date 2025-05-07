package com.example.greenleaf.presentation.navigation

sealed class Screen(val route: String) {
    object Login : Screen("login")
    object SignUp : Screen("signup")
    object Home : Screen("home")
    object Profile : Screen("profile")
    object PlantDetail : Screen("plant_detail/{plantId}") {
        fun createRoute(plantId: String) = "plant_detail/$plantId"
    }
    object ObservationDetail : Screen("observation_detail/{observationId}") {
        fun createRoute(observationId: String) = "observation_detail/$observationId"
    }
    object AddEditPlant : Screen("add_edit_plant/{plantId?}") {
        fun createRoute(plantId: String?): String =
            if (plantId != null) "add_edit_plant/$plantId" else "add_edit_plant"
    }
    // in com.example.greenleaf.presentation.navigation.Screen
    object AddEditObservation : Screen("add_edit_observation/{observationId?}") {
        /**
         * If observationId is null, this yields "add_edit_observation",
         * otherwise "add_edit_observation/12345"
         */
        fun createRoute(observationId: String?): String =
            if (observationId != null) "add_edit_observation/$observationId"
            else "add_edit_observation"
    }

    object AdminDashboard : Screen("admin_dashboard")
    object EditProfile : Screen("edit_profile")

}