




library(httr2)
library(magrittr)

resp <- request("https://places.googleapis.com/v1/places:searchNearby") %>%
  req_headers(
    "Content-Type" = "application/json",
    "X-Goog-Api-Key" = Sys.getenv("GOOGLE_MAPS_KEY"),
    "X-Goog-FieldMask" = "places.displayName,places.formattedAddress,places.location"
  ) %>%
  req_body_json(list(
    includedTypes = list("hardware_store"),
    maxResultCount = 3,
    locationRestriction = list(
      circle = list(
        center = list(latitude = 19.4326, longitude = -99.1332),
        radius = 1000
      )
    )
  )) %>%
  req_perform() %>%
  resp_body_json()

# Ver resultados
resp$places %>%
  lapply(function(p) {
    data.frame(
      nombre = p$displayName$text,
      direccion = p$formattedAddress,
      lat = p$location$latitude,
      lon = p$location$longitude
    )
  }) %>%
  do.call(rbind, .)
