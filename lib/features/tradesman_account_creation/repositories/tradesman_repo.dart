import 'package:dio/dio.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/request/add_inquiry_request_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/request/add_review_request_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/request/tradesman_area_request_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/add_inquiry_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/add_review_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/get_advertise_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/get_all_tradesman_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/get_client_profile_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/get_skill_listed_count_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/go_live_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/tell_clients_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/tradesman_area_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/tradesman_skill_response_model.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/model/response/update_profile_response_model.dart';

import '../../../core/network/network_result.dart';
import '../model/request/tradesman_skill_request_model.dart';
import '../model/response/dashboard_response_model.dart';
import '../model/response/get_specific_tradesman_response_model.dart';

abstract class TradesmanRepo {
  NetworkResult<TradesmanSkillResponseModel> whatCanDo(
    TradesmanSkillRequestModel request,
  );
  NetworkResult<TradesmanAreaResponseModel> tradesmanArea(
    TradesmanAreaRequestModel request,
  );
  NetworkResult<AddReviewResponseModel> addReview(
    AddReviewRequestModel request,
    String tradesmanId,
  );
  NetworkResult<TellClientsResponseModel> tellClient(FormData formData);
  NetworkResult<dynamic> removeWorkPhoto({
    required String publicId,
    required String url,
    required String photoId,
  });
  NetworkResult<GoLiveResponseModel> goLive();
  NetworkResult<TradesmanDashboardResponse> dashboard();
  NetworkResult<TradesmanDashboardResponse> updateProfile(FormData formData);
  NetworkResult<List<SkillModel>> getSkillList();
  NetworkResult<GetSpecificTradesmanResponseModel> getSpecifiedTradesman(
    String tradesmanId,
  );
  NetworkResult<GetClientProfileResponseModel> getClientProfile();
  NetworkResult<UpdateProfileResponseModel> updateClientProfile(
    FormData formData,
  );
  NetworkResult<GetAllTradesmanResponseModel> getTradesman({
    required String skill,
    String search,
    String area,
    String sort,
    int page,
    int limit,
  });

  NetworkResult<AddInquiryResponseModel> addInquiry(
    AddInquiryRequestModel request,
  );
  NetworkResult<GetAdvertiseResponseModel> getAdvertise({String category = ''});
}
