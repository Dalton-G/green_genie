import 'package:green_genie/model/carbon_emission_response.dart';
import 'package:green_genie/model/transportation_request.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://carbonsutra1.p.rapidapi.com")
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;

  @POST('/vehicle_estimate_by_type')
  Future<CarbonEmissionResponse> estimateVehicleEmission(
    @Body() TransportationRequest request,
    @Header("Authorization") String bearerToken,
    @Header("x-rapidapi-host") String apiHost,
    @Header("x-rapidapi-key") String apiKey,
  );
}
