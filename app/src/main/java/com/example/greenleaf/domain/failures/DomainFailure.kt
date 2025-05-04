package com.example.greenleaf.domain.failures

sealed class DomainFailure(val message: String?) {
    class ValidationError(message: String) : DomainFailure(message)
    class NetworkError(message: String? = null) : DomainFailure(message)
    class DatabaseError(message: String? = null) : DomainFailure(message)
    class Unauthorized(message: String? = null) : DomainFailure(message)
}