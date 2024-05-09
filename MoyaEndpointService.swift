import UIKit

import Moya

enum MoyaEndpointService {
    case signUp(phone: String)
    case signIn(phone: String)
    case confirmSignUp(phone: String, otp: Int)
    case confirmSignIn(phone: String, otp: Int)
    case getUserProfile
    case getTwilioToken
    case updatePersonalInformation(model: UserInputModel)
    case updateUserSettings
    case intakeForm(model: UserInputModel)
    case refreshToken
    case deleteAccount
    case signOut
    
    case getScannedDrink(barcode: String)
    
    case getShippingAddresses
    case postShippingAddress(shippingAddress: BillingDetailsModel)
    case deleteShippingAddress(id: String)
    
    case getFamilyMembers
    case addFamilyMember(model: UserInputModel)
    case deleteFamilyMember(id: String)
    case updateFamilyMember(id: String, model: UserInputModel)
    
    case getHydrationForToday(id: String?)
    case getPeriodHydration(id: String?, startDate: Int, endDate: Int)
    case getWeekHydrationStatistics(id: String?, startDate: Int, endDate: Int)
    case getMonthHydrationStatistics(id: String?, startDate: Int, endDate: Int)
    
    
    case getRecomendedHydration
    case getRecomendedHydrationForFamilyMember(id: String)
    case getDailyHydration
    case getDailyHydrationForDates(startDate: Int, endDate: Int)
    case getDailyHydrationForFamilyMember(id: String)
    case getDailyHydrationForFamilyMemberForDates(id: String, startDate: Int, endDate: Int)
    case getMoodHistory
    case getFamilyMoodHistory(id: String)
    case putTodaysMood(moodModel: MoodModel)
    case putFamilyMemberTodaysMood(id: String, moodModel: MoodModel)
    
    case getUserDrinks
    case getFamilyMemberUserDrinks(id: String)
    case postDrink(drinkModel: UserDrinkModel)
    case postFamilyMemberDrink(id: String, drinkModel: UserDrinkModel)
    case deleteUserDrink(drinkName: String)
    case deleteFamilyMemmberUserDrink(drinkName: String, id: String)
    
    case getWaterConsumptionHistory
    case getWaterConsumptionHistoryForDates(startDate: Int, endDate: Int)
    case getFamilyWaterConsumptionHistory(id: String)
    case getFamilyWaterConsumptionHistoryForDates(id: String, startDate: Int, endDate: Int)
    case postWaterConsumption(waterConsumption: WaterConsumptionModel)
    case postFamilyMemberWaterConsumption(waterConsumption: WaterConsumptionModel, id: String)
    case deleteDrinkFromWaterConsumptionHistory(id: String)
    case deleteFamilyMemberDrinkFromWaterConsumptionHistory(memberId: String, id: String)
    
    case getProducts
    case addProductToCart(id: String, productQuantity: Int)
    case removeProductFromCart(id: String)
    case getProductsInCart
    
    case addPaymentMethod(card: AddPaymentCardModel)
    case deletePaymentMethod(paymentId: String)
    case getPaymentMethods
    
    case orders
    case createOrder(order: PostOrderModel)
    case getDeliveryId
    
    case cancelAndRefundOrder(id: String)
    case confirmDeliveryOrder(id: String , userId: String)
    case requestReturnAndRefundOrder(id: String)
    case makeOrderReady(id: String)
    case collectOrder(id: String)
    
    case getSubscriptions
    case getSubscriptionCases
    case postSubscription(model: PostSubscriptionModel)
    case updateSubscription(id: String, model: PostSubscriptionModel)
    case cancelSubscription(id: String)
    case payForSubscription(id: String)
    
    case sendFirebaseToken(token: String?)
    
    case getEvents(date: Int64)
    
    case postOrderForApplePay(order: PostOrderModel)
    
    case inviteFriends(inviteModel: [InviteLinkModel])
}

extension MoyaEndpointService: TargetType {
    public var baseURL: URL {
        switch self {
        default:
            return URL(string: Constants.baseUrl.rawValue)!
        }
    }

    public var path: String {
        switch self {
        case .signUp:
            return "/users/initiate-sign-up"
        case .signIn:
            return "/users/initiate-sign-in"
        case .confirmSignUp:
            return "/users/confirm-sign-up"
        case .confirmSignIn:
            return "/users/confirm-sign-in"
        case .getUserProfile:
            return "/users/profile"
        case .updatePersonalInformation:
            return "/users/personal-information"
        case .updateUserSettings:
            return "/users/settings"
        case .intakeForm:
            return "/users/intake-form"
        case .refreshToken:
            return "/users/refresh-token"
        case .deleteAccount:
            return "/user/account"
        case .getTwilioToken:
            return "/users/twilio-token"
        case .signOut:
            return "/users/sign-out"
            
        case .getShippingAddresses:
            return "/users/shipping-addresses"
        case .postShippingAddress:
            return "/users/shipping-address"
        case .deleteShippingAddress(let id):
            return "/users/shipping-addresses/\(id)"
            
        case .getFamilyMembers:
            return "/users/family-members"
        case .addFamilyMember:
            return "/users/family-member"
        case .deleteFamilyMember(let id):
            return "/users/family-members/\(id)"
        case .updateFamilyMember(let id, _):
            return "/users/personal-information?family_id=\(id)"
            
        case .getHydrationForToday:
            return "/hydration/today"
        case .getPeriodHydration:
            return "/hydration/period"
        case .getWeekHydrationStatistics:
            return "/hydration/weeks"
        case .getMonthHydrationStatistics:
            return "/hydration/months"
            
            
        case .getRecomendedHydration:
            return "/hydration/recommended-hydration"
        case .getRecomendedHydrationForFamilyMember(let id):
            return "/hydration/recommended-hydration?family_id=\(id)"
        case .getDailyHydration:
            return "/hydration/daily-hydration"
        case .getDailyHydrationForDates(let startDate, let endDate):
            return "/hydration/daily-hydration?start_date=\(startDate)&end_date=\(endDate)"
        case .getDailyHydrationForFamilyMember(let id):
            return "/hydration/daily-hydration?family_id=\(id)"
        case .getDailyHydrationForFamilyMemberForDates(let id, let startDate, let endDate):
            return "/hydration/daily-hydration?family_id=\(id)&start_date=\(startDate)&end_date=\(endDate)"
        case .deleteDrinkFromWaterConsumptionHistory(let id):
            return "/hydration/water-consumption/\(id)"
        case .deleteFamilyMemberDrinkFromWaterConsumptionHistory(let familyMemberID, let id):
            return "/hydration/water-consumption/\(id)?family_id=\(familyMemberID)"
            
        case .getMoodHistory,
             .putTodaysMood:
            return "/hydration/mood"
            
        case .getFamilyMoodHistory(let id),
             .putFamilyMemberTodaysMood(let id, _):
            return "/hydration/mood?family_id=\(id)"
            
        case .getUserDrinks:
            return "/hydration/drinks"
        case .getFamilyMemberUserDrinks(let id):
            return "/hydration/drinks?family_id=\(id)"
        case .postDrink:
            return "/hydration/drink"
        case .postFamilyMemberDrink(let id, _):
            return "/hydration/drink?family_id=\(id)"
        case .deleteUserDrink(let drinkName):
            return "/hydration/drinks/\(drinkName)"
        case .deleteFamilyMemmberUserDrink(let drinkName, let id):
            return "/hydration/drinks/\(drinkName)?family_id=\(id)"
            
        case .getWaterConsumptionHistory,
             .postWaterConsumption:
            return "/hydration/water-consumption"
        case .getWaterConsumptionHistoryForDates(let startDate, let endDate):
            return "/hydration/water-consumption?start_date=\(startDate)&end_date=\(endDate)"
            
        case .getFamilyWaterConsumptionHistory(let id),
             .postFamilyMemberWaterConsumption(_ ,let id):
            return "/hydration/water-consumption?family_id=\(id)"
            
        case .getFamilyWaterConsumptionHistoryForDates(let id, let startDate, let endDate):
            return "/hydration/water-consumption?family_id=\(id)&start_date=\(startDate)&end_date=\(endDate)"
            
        case .getProducts:
            return "/products"
        case .addProductToCart(let id, _),
             .removeProductFromCart(let id):
            return "/products/\(id)/cart"
        case .getProductsInCart:
            return "/products/cart"
            
        case .addPaymentMethod:
            return "/users/payment-method"
        case .deletePaymentMethod(let paymentId):
            return "/users/payment-methods/\(paymentId)"
        case .getPaymentMethods:
            return "/users/payment-methods"
            
        case .orders:
            return "/orders"
        case .createOrder:
            return "/order"
        case .getDeliveryId:
            return "/order/deliveries"
            
        case .cancelAndRefundOrder(let id):
            return "/orders/\(id)/cancel"
        case .confirmDeliveryOrder(let id, _):
            return "/orders/\(id)/deliver"
        case .requestReturnAndRefundOrder(let id):
            return "/orders/\(id)/return"
        case .makeOrderReady(let id):
            return "/orders/\(id)/make-ready"
        case .collectOrder(let id):
            return "/orders/\(id)/collect"
         
        case .getSubscriptions:
            return "/subscriptions"
        case .getSubscriptionCases:
            return "/subscriptions/cases"
        case .postSubscription:
            return "/subscription"
        case .updateSubscription(let id, _):
            return "/subscriptions/\(id)"
        case .cancelSubscription(let id):
            return "/subscriptions/\(id)/cancel"
        case .payForSubscription(let id):
            return "/subscriptions/\(id)/resume"
            
        case .sendFirebaseToken:
            return "/default/push-token"
            
        case .getScannedDrink(let barcode):
            return "/products/bar-codes/\(barcode)"
        case .getEvents:
            return "/events"
            
        case .postOrderForApplePay:
            return "/order"
            
        case .inviteFriends:
            return "/users/invite-friends"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .signUp,
             .signIn,
             .confirmSignUp,
             .confirmSignIn,
             .postDrink,
             .postFamilyMemberDrink,
             .postWaterConsumption,
             .postFamilyMemberWaterConsumption,
             .addProductToCart,
             .addPaymentMethod,
             .addFamilyMember,
             .postShippingAddress,
             .createOrder,
             .cancelAndRefundOrder,
             .confirmDeliveryOrder,
             .requestReturnAndRefundOrder,
             .postSubscription,
             .cancelSubscription,
             .payForSubscription,
             .refreshToken,
             .sendFirebaseToken,
             .postOrderForApplePay,
             .signOut,
             .inviteFriends:
            return .post
        case .intakeForm,
             .updatePersonalInformation,
             .updateUserSettings,
             .updateFamilyMember,
             .putTodaysMood,
             .putFamilyMemberTodaysMood,
             .updateSubscription:
            return .put
        case .removeProductFromCart,
             .deletePaymentMethod,
             .deleteFamilyMember,
             .deleteShippingAddress,
             .deleteUserDrink,
             .deleteFamilyMemmberUserDrink,
             .deleteDrinkFromWaterConsumptionHistory,
             .deleteFamilyMemberDrinkFromWaterConsumptionHistory,
             .deleteAccount:
            return .delete
        default:
            return .get
        }
    }

    public var task: Task {
        switch self {
        case .signUp(let phone), .signIn(let phone):
            let parameters = [
                "phone": phone
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .confirmSignIn(let phone, let otp):
            let parameters = [
                "phone": phone,
                "otp": otp
            ] as [String: Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .confirmSignUp(let phone, let otp):
            let parameters = [
                "phone": phone,
                "otp": otp,
                "inviterId": UserManager.shared.inviterId ?? nil,
                "inviteToken": UserManager.shared.inviteToken ?? nil
            ] as [String: Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .updatePersonalInformation(let model),
             .intakeForm(let model),
             .addFamilyMember(let model),
             .updateFamilyMember(_ ,let model):
            let parameters = [
                "gender": model.gender ?? "",
                "femaleState": model.femaleState ?? "",
                "birth": model.birth ?? 0,
                "firstName": model.firstName ?? "",
                "lastName": model.lastName ?? "",
                "email": model.email ?? "",
                "climate": model.climate ?? "",
                "activity": model.activity ?? "",
                "activityDuration": model.activityDuration ?? "",
                "measurement": model.measurement ?? "",
                "height": model.height ?? 0,
                "weight": model.weight ?? 0
            ] as [String: Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .updateUserSettings:
            let parameters = [
                "measurement": "imp",
                "language": "eng",
                "country": "us",
                "currency": "usDollar",
                "notificationTime": 86400000
            ] as [String: Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .putTodaysMood(let model),
             .putFamilyMemberTodaysMood(_ , let model):
            let parameters = [
                "userMood": model.userMood ?? "",
                "userSymptoms": model.userSymptoms ?? [String]()
            ] as [String: Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .postDrink(let model),
             .postFamilyMemberDrink(_ , let model):
            let parameters = [
                "drinkName": model.drinkName?.replacingOccurrences(of: " ", with: "") ?? "",
                "hydration": model.hydration ?? 0,
                "drinkDisplayName": model.drinkName ?? ""
            ] as [String: Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .postWaterConsumption(let model),
             .postFamilyMemberWaterConsumption(let model, _):
            let parameters = [
                "drinkName": model.drinkName ?? "",
                "volume": model.volume ?? 0,
                "hydration": model.hydration ?? 0,
                "measurement": UserManager.shared.user?.settings?.measurement ?? ""
            ] as [String: Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .addProductToCart(_ , let productQuantity):
            let parameters = [
                "productQuantity": productQuantity
            ] as [String: Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .addPaymentMethod(let cardModel):
            let address = [
                "country": cardModel.billing_details?.address?.country ?? "",
                "city": cardModel.billing_details?.address?.city ?? "",
                "state": cardModel.billing_details?.address?.state ?? "",
                "line1": cardModel.billing_details?.address?.line1 ?? "",
                "line2": cardModel.billing_details?.address?.line2 ?? "",
                "postal_code": cardModel.billing_details?.address?.postal_code ?? "",
                "appartment": cardModel.billing_details?.address?.appartment ?? ""
            ] as [String: Any]
            let billingDetails = [
                "name": cardModel.billing_details?.name ?? "",
                "phone": cardModel.billing_details?.phone ?? "",
                "email": cardModel.billing_details?.email ?? "",
                "address": address
            ] as [String: Any]
            let card = [
                "number": cardModel.card?.number ?? "",
                "exp_month": cardModel.card?.exp_month ?? "",
                "exp_year": cardModel.card?.exp_year ?? "",
                "cvc": cardModel.card?.cvv ?? ""
            ] as [String: Any]
            let parameters = [
                "type": cardModel.type ?? "",
                "card": card,
                "billing_details": billingDetails
            ] as [String: Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .postShippingAddress(let shippingAddress):
            let address = [
                "country": shippingAddress.address?.country ?? "",
                "city": shippingAddress.address?.city ?? "",
                "state": shippingAddress.address?.state ?? "",
                "line1": shippingAddress.address?.line1 ?? "",
                "line2": shippingAddress.address?.line2 ?? "",
                "postal_code": shippingAddress.address?.postal_code ?? "",
                "appartment": shippingAddress.address?.appartment ?? ""
            ] as [String: Any]
            let parameters = [
                "name": shippingAddress.name ?? "",
                "email": shippingAddress.email ?? "",
                "phone": shippingAddress.phone ?? "",
                "address": address
            ] as [String: Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .createOrder(let order):
            var parameters = [
                "orderId": order.orderId ?? "",
                "paymentMethodId": order.paymentMethodId ?? "",
                "deliveryMethod": order.deliveryMethod ?? ""
            ] as [String: Any]
            if order.deliveryMethod == DeliveryMethodCheckboxOption.doorDelivery.getApiOption() {
                let address = [
                    "country": order.deliveryDetails?.address?.country ?? "",
                    "city": order.deliveryDetails?.address?.city ?? "",
                    "state": order.deliveryDetails?.address?.state ?? "",
                    "line1": order.deliveryDetails?.address?.line1 ?? "",
                    "line2": order.deliveryDetails?.address?.line2 ?? "",
                    "postal_code": order.deliveryDetails?.address?.postal_code ?? "",
                    "appartment": order.deliveryDetails?.address?.appartment ?? ""
                ] as [String: Any]
                let deliveryDetails = [
                    "name": order.deliveryDetails?.name ?? "",
                    "phone": order.deliveryDetails?.phone ?? "",
                    "email": order.deliveryDetails?.email ?? "",
                    "address": address
                ] as [String: Any]
                parameters["deliveryDetails"] = deliveryDetails
                parameters["deliveryId"] = UserManager.shared.deliveryId ?? 0
            }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .confirmDeliveryOrder(_ , let userId):
            let parameters = [
                "userId": userId 
            ] as [String: Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .postSubscription(let model):
            var parameters = [
                "caseId": model.caseId ?? "",
                "paymentMethodId": model.paymentMethodId ?? "",
                "caseAmount": model.caseAmount ?? 1,
                "deliveryTime": model.deliveryTime ?? "",
                "deliveryNotes": model.deliveryNotes ?? "",
                "deliveryMethod": model.deliveryMethod ?? ""
            ] as [String: Any]
            let recurring = [
                "interval": model.recurring?.interval ?? "",
                "interval_count": model.recurring?.interval_count ?? ""
            ] as [String: Any]
            parameters["recurring"] = recurring
            if model.deliveryMethod == DeliveryMethodCheckboxOption.doorDelivery.getApiOption() {
                let address = [
                    "country": model.deliveryDetails?.address?.country ?? "",
                    "city": model.deliveryDetails?.address?.city ?? "",
                    "state": model.deliveryDetails?.address?.state ?? "",
                    "line1": model.deliveryDetails?.address?.line1 ?? "",
                    "line2": model.deliveryDetails?.address?.line2 ?? "",
                    "postal_code": model.deliveryDetails?.address?.postal_code ?? "",
                    "appartment": model.deliveryDetails?.address?.appartment ?? ""
                ] as [String: Any]
                let deliveryDetails = [
                    "name": model.deliveryDetails?.name ?? "",
                    "phone": model.deliveryDetails?.phone ?? "",
                    "email": model.deliveryDetails?.email ?? "",
                    "address": address
                ] as [String: Any]
                parameters["deliveryDetails"] = deliveryDetails
                let recurring = [
                    "interval": model.caseDeilvery?.recuring?.interval ?? "",
                    "interval_count":  model.caseDeilvery?.recuring?.interval_count ?? ""
                ] as [String: Any]
                let caseDelivery = [
                    "deliveryPrice": model.caseDeilvery?.deliveryPrice ?? 0,
                    "deliveryName":  model.caseDeilvery?.deliveryName ?? "",
                    "recuring": recurring
                ] as [String: Any]
                parameters["caseDelivery"] = caseDelivery
            }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .updateSubscription(_ , let model):
            var parameters = [
                "deliveryTime": model.deliveryTime ?? "",
                "deliveryMethod": model.deliveryMethod ?? "",
                "paymentMethodId": model.paymentMethodId ?? ""
            ] as [String: Any]
            if model.deliveryMethod == DeliveryMethodCheckboxOption.doorDelivery.getApiOption() {
                let address = [
                    "country": model.deliveryDetails?.address?.country ?? "",
                    "city": model.deliveryDetails?.address?.city ?? "",
                    "state": model.deliveryDetails?.address?.state ?? "",
                    "line1": model.deliveryDetails?.address?.line1 ?? "",
                    "line2": model.deliveryDetails?.address?.line2 ?? "",
                    "postal_code": model.deliveryDetails?.address?.postal_code ?? "",
                    "appartment": model.deliveryDetails?.address?.appartment ?? ""
                ] as [String: Any]
                let deliveryDetails = [
                    "name": model.deliveryDetails?.name ?? "",
                    "phone": model.deliveryDetails?.phone ?? "",
                    "email": model.deliveryDetails?.email ?? "",
                    "address": address
                ] as [String: Any]
                parameters["deliveryDetails"] = deliveryDetails
            }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .sendFirebaseToken(let token):
            let parameters = [
                "pushToken": token ?? "",
                "deviceId": UIDevice.current.identifierForVendor?.uuidString ?? "",
                "deviceType": "ios"
            ] as [String: Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .postOrderForApplePay(let order):
            var parameters = [
                "orderId": order.orderId ?? "",
                "paymentType": "apple-pay",
                "deliveryMethod": order.deliveryMethod ?? ""
            ] as [String: Any]
            if order.deliveryMethod == DeliveryMethodCheckboxOption.doorDelivery.getApiOption() {
                let address = [
                    "country": order.deliveryDetails?.address?.country ?? "",
                    "city": order.deliveryDetails?.address?.city ?? "",
                    "state": order.deliveryDetails?.address?.state ?? "",
                    "line1": order.deliveryDetails?.address?.line1 ?? "",
                    "line2": order.deliveryDetails?.address?.line2 ?? "",
                    "postal_code": order.deliveryDetails?.address?.postal_code ?? "",
                    "appartment": order.deliveryDetails?.address?.appartment ?? ""
                ] as [String: Any]
                let deliveryDetails = [
                    "name": order.deliveryDetails?.name ?? "",
                    "phone": order.deliveryDetails?.phone ?? "",
                    "email": order.deliveryDetails?.email ?? "",
                    "address": address
                ] as [String: Any]
                parameters["deliveryDetails"] = deliveryDetails
                parameters["deliveryId"] = UserManager.shared.deliveryId ?? 0
            }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .signOut:
            let parameters = [
                "deviceId": UIDevice.current.identifierForVendor?.uuidString ?? ""
            ] as [String: Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .inviteFriends(let inviteModel):
            var invites = [[String: Any]]()
            for element in inviteModel {
                let invite = [
                    "inviteToken": element.inviteToken,
                    "link": element.link,
                    "phone": element.phone
                ] as [String: Any]
                invites.append(invite)
            }
            let parameters = [
                "invites": invites
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getEvents(let date):
            let parameters = [
                "date": date
            ] as [String: Any]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getHydrationForToday(let familyId):
            var parameters = [:] as [String: Any]
            if let familyId {
                parameters = [
                    "family_id": familyId
                ] as [String: Any]
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getPeriodHydration(let familyId, let startDate, let endDate):
            var parameters = [
                "start_date": startDate,
                "end_date": endDate
            ] as [String: Any]
            if let familyId {
                parameters["family_id"] = familyId
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getWeekHydrationStatistics(let familyId, let startDate, let endDate):
            var parameters = [
                "start_date": startDate,
                "end_date": endDate
            ] as [String: Any]
            if let familyId {
                parameters["family_id"] = familyId
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getMonthHydrationStatistics(let familyId, let startDate, let endDate):
            var parameters = [
                "start_date": startDate,
                "end_date": endDate
            ] as [String: Any]
            if let familyId {
                parameters["family_id"] = familyId
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .getUserProfile,
             .updatePersonalInformation,
             .updateUserSettings,
             .intakeForm,
             .getRecomendedHydration,
             .getRecomendedHydrationForFamilyMember,
             .getDailyHydration,
             .getDailyHydrationForDates,
             .getDailyHydrationForFamilyMember,
             .getDailyHydrationForFamilyMemberForDates,
             .getMoodHistory,
             .getFamilyMoodHistory,
             .getUserDrinks,
             .getFamilyMemberUserDrinks,
             .postDrink,
             .postFamilyMemberDrink,
             .getWaterConsumptionHistory,
             .getWaterConsumptionHistoryForDates,
             .getFamilyWaterConsumptionHistory,
             .getFamilyWaterConsumptionHistoryForDates,
             .postWaterConsumption,
             .postFamilyMemberWaterConsumption,
             .getProducts,
             .addProductToCart,
             .removeProductFromCart,
             .getProductsInCart,
             .addPaymentMethod,
             .deletePaymentMethod,
             .getPaymentMethods,
             .orders,
             .createOrder,
             .getShippingAddresses,
             .postShippingAddress,
             .deleteShippingAddress,
             .getFamilyMembers,
             .addFamilyMember,
             .deleteFamilyMember,
             .updateFamilyMember,
             .deleteUserDrink,
             .deleteFamilyMemmberUserDrink,
             .deleteDrinkFromWaterConsumptionHistory,
             .deleteFamilyMemberDrinkFromWaterConsumptionHistory,
             .putTodaysMood,
             .putFamilyMemberTodaysMood,
             .cancelAndRefundOrder,
             .confirmDeliveryOrder,
             .requestReturnAndRefundOrder,
             .getSubscriptions,
             .getSubscriptionCases,
             .postSubscription,
             .updateSubscription,
             .cancelSubscription,
             .payForSubscription,
             .refreshToken,
             .sendFirebaseToken,
             .deleteAccount,
             .getScannedDrink,
             .getDeliveryId,
             .getEvents,
             .getTwilioToken,
             .postOrderForApplePay,
             .signOut,
             .inviteFriends,
             .getHydrationForToday,
             .getPeriodHydration,
             .getWeekHydrationStatistics,
             .getMonthHydrationStatistics:
            return [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer \(KeychainService.get(key: .accessToken) ?? "")"
            ]
        default:
            return [
                "Content-Type": "application/x-www-form-urlencoded",
                "Accept": "application/json"
            ]
        }
    }

    public var sampleData: Data {
        return Data()
    }
}

