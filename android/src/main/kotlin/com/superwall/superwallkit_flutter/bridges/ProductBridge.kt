import com.superwall.sdk.models.product.Product
import com.superwall.sdk.models.product.ProductType

fun Product.toJson(): Map<String, Any> {
    return mapOf(
        "type" to this.type.toJson(),
        "id" to this.id
    )
}

fun ProductType.toJson(): String {
    return when (this) {
        ProductType.PRIMARY -> "primary"
        ProductType.SECONDARY -> "secondary"
        ProductType.TERTIARY -> "tertiary"
    }
}
