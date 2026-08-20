import 'package:dio/dio.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/add_inquiry_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/tell_clients_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/repositories/tradesman_repo.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/network_result.dart';
import '../../../core/network/constants/api_constants.dart';
import '../model/request/add_inquiry_request_model.dart';
import '../model/request/add_review_request_model.dart';
import '../model/request/tradesman_area_request_model.dart';
import '../model/request/tradesman_skill_request_model.dart';
import '../model/response/add_review_response_model.dart';
import '../model/response/dashboard_response_model.dart';
import '../model/response/get_advertise_response_model.dart';
import '../model/response/get_all_tradesman_response_model.dart';
import '../model/response/get_client_profile_response_model.dart';
import '../model/response/get_skill_listed_count_response_model.dart';
import '../model/response/get_specific_tradesman_response_model.dart';
import '../model/response/go_live_response_model.dart';
import '../model/response/tradesman_area_response_model.dart';
import '../model/response/tradesman_skill_response_model.dart';
import '../model/response/update_profile_response_model.dart';

class TradesmanRepositoryImpl implements TradesmanRepo {
  final ApiClient _apiClient;

  TradesmanRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  NetworkResult<TradesmanSkillResponseModel> whatCanDo(
    TradesmanSkillRequestModel request,
  ) {
    return _apiClient.post(
      endpoint: ApiConstants.tradesman.whatCan,
      data: request.toJson(),
      fromJsonT: (json) => TradesmanSkillResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<AddInquiryResponseModel> addInquiry(
    AddInquiryRequestModel request,
  ) {
    return _apiClient.post(
      endpoint: ApiConstants.user.addInquiry,
      data: request.toJson(),
      fromJsonT: (json) => AddInquiryResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<TradesmanAreaResponseModel> tradesmanArea(
    TradesmanAreaRequestModel request,
  ) {
    return _apiClient.post(
      endpoint: ApiConstants.tradesman.whereWork,
      data: request.toJson(),
      fromJsonT: (json) => TradesmanAreaResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<TellClientsResponseModel> tellClient(FormData formData) {
    return _apiClient.post(
      endpoint: ApiConstants.tradesman.tellClient,
      formData: formData,
      fromJsonT: (json) => TellClientsResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<dynamic> removeWorkPhoto({
    required String publicId,
    required String url,
    required String photoId,
  }) {
    return _apiClient.post(
      endpoint: ApiConstants.tradesman.deletePhoto,
      data: {
        'removeWorkPhoto': publicId.isNotEmpty
            ? publicId
            : photoId.isNotEmpty
            ? photoId
            : url,
        'publicId': publicId,
        'public_id': publicId,
        'url': url,
        'photoId': photoId,
      },
      fromJsonT: (json) => json,
    );
  }

  @override
  NetworkResult<AddReviewResponseModel> addReview(
    AddReviewRequestModel request,
    String tradesmanId,
  ) {
    return _apiClient.post(
      endpoint: ApiConstants.user.review(tradesmanId),
      data: request.toJson(),
      fromJsonT: (json) => AddReviewResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<GoLiveResponseModel> goLive() {
    return _apiClient.post(
      endpoint: ApiConstants.tradesman.goLive,
      fromJsonT: (json) => GoLiveResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<TradesmanDashboardResponse> updateProfile(FormData formData) {
    return _apiClient.put(
      endpoint: ApiConstants.tradesman.updateProfile,
      formData: formData,
      fromJsonT: (json) =>
          TradesmanDashboardResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  NetworkResult<TradesmanDashboardResponse> dashboard() {
    return _apiClient.get(
      endpoint: ApiConstants.tradesman.dashboard,
      fromJsonT: (json) =>
          TradesmanDashboardResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  NetworkResult<GetClientProfileResponseModel> getClientProfile() {
    return _apiClient.get(
      endpoint: ApiConstants.user.getProfile,
      fromJsonT: (json) =>
          GetClientProfileResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  NetworkResult<GetSpecificTradesmanResponseModel> getSpecifiedTradesman(
    String tradesmanId,
  ) {
    return _apiClient.get(
      endpoint: ApiConstants.user.tradesmanDetails(tradesmanId),
      fromJsonT: GetSpecificTradesmanResponseModel.fromData,
    );
  }

  @override
  NetworkResult<UpdateProfileResponseModel> updateClientProfile(
    FormData formData,
  ) {
    return _apiClient.put(
      endpoint: ApiConstants.user.updateProfile,
      formData: formData,
      fromJsonT: (json) =>
          UpdateProfileResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  NetworkResult<List<SkillModel>> getSkillList() {
    return _apiClient.get(
      endpoint: ApiConstants.user.home,
      fromJsonT: skillListFromJson,
    );
  }

  @override
  NetworkResult<GetAdvertiseResponseModel> getAdvertise() {
    return _apiClient.get(
      endpoint: ApiConstants.user.getInquiry,
      fromJsonT: GetAdvertiseResponseModel.fromData,
    );
  }

  @override
  NetworkResult<GetAllTradesmanResponseModel> getTradesman({
    required String skill,
    String search = '',
    String area = '',
    String sort = 'rating',
    int page = 1,
    int limit = 20,
  }) {
    return _apiClient.get(
      endpoint: ApiConstants.user.categoryDetails(
        skill: skill,
        search: search,
        area: area,
        sort: sort,
        page: page,
        limit: limit,
      ),
      fromJsonT: GetAllTradesmanResponseModel.fromData,
    );
  }
}
