import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherService{
 final String apiKey ="b279498c7567432391c82037251001";
 final String forcecastBaseUrl ="http://api.weatherapi.com/v1/forecast.json";
 final String searchBaseUrl ="http://api.weatherapi.com/v1/search.json";

 Future<Map<String, dynamic>> fetchCurrentWeather(String city) async {
  final url = '$forcecastBaseUrl?key=$apiKey&q=$city&days=1&aqi=no&alerts=no';
  final response = await http.get(Uri.parse(url));
  if(response.statusCode == 200){
   return json.decode(response.body);
   }else{
    throw Exception('Failed to load weather data');
   }
 }

 Future<Map<String, dynamic>> fetch7DayForecast(String city) async {
  final url = '$forcecastBaseUrl?key=$apiKey&q=$city&days=7&aqi=no&alerts=no';
  final response = await http.get(Uri.parse(url));
  if(response.statusCode == 200){
   return json.decode(response.body);
   }else{
    throw Exception('Failed to load forecast data');
   }
 }

  Future<List<dynamic>?> fetchCitySuggestions(String query) async {
  final url = '$searchBaseUrl?key=$apiKey&q=$query';
  final response = await http.get(Uri.parse(url));
  if(response.statusCode == 200){
   return json.decode(response.body);
   }else{
    return null;
   }
 }
}