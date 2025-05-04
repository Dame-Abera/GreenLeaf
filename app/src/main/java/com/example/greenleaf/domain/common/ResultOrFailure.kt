package com.example.greenleaf.domain.common

import com.example.greenleaf.domain.failures.DomainFailure

sealed class ResultOrFailure<out T> {
    data class Success<out T>(val value: T): ResultOrFailure<T>()
    data class Failure(val failure: DomainFailure): ResultOrFailure<Nothing>()
}