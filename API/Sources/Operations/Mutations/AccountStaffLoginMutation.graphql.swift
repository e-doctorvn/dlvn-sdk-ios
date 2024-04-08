// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class AccountStaffLoginMutation: GraphQLMutation {
  public static let operationName: String = "AccountStaffLogin"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation AccountStaffLogin($input: StaffLoginInput) { accountStaffLogin(input: $input) { __typename isSucceeded accessToken uploadToken staff { __typename role eClinicIds scopes slug phone email isActive account { __typename accountId fullName } eClinics { __typename eClinicId slug displayName } tags } } }"#
    ))

  public var input: GraphQLNullable<StaffLoginInput>

  public init(input: GraphQLNullable<StaffLoginInput>) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: API.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { API.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("accountStaffLogin", AccountStaffLogin?.self, arguments: ["input": .variable("input")]),
    ] }

    public var accountStaffLogin: AccountStaffLogin? { __data["accountStaffLogin"] }

    /// AccountStaffLogin
    ///
    /// Parent Type: `StaffLoginResponse`
    public struct AccountStaffLogin: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.StaffLoginResponse }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("isSucceeded", Bool?.self),
        .field("accessToken", String?.self),
        .field("uploadToken", String?.self),
        .field("staff", Staff?.self),
      ] }

      public var isSucceeded: Bool? { __data["isSucceeded"] }
      public var accessToken: String? { __data["accessToken"] }
      public var uploadToken: String? { __data["uploadToken"] }
      public var staff: Staff? { __data["staff"] }

      /// AccountStaffLogin.Staff
      ///
      /// Parent Type: `Staff`
      public struct Staff: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.Staff }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("role", String?.self),
          .field("eClinicIds", [String?]?.self),
          .field("scopes", [String?]?.self),
          .field("slug", String?.self),
          .field("phone", String?.self),
          .field("email", String?.self),
          .field("isActive", Bool?.self),
          .field("account", Account?.self),
          .field("eClinics", [EClinic?]?.self),
          .field("tags", [String?]?.self),
        ] }

        public var role: String? { __data["role"] }
        public var eClinicIds: [String?]? { __data["eClinicIds"] }
        public var scopes: [String?]? { __data["scopes"] }
        public var slug: String? { __data["slug"] }
        public var phone: String? { __data["phone"] }
        public var email: String? { __data["email"] }
        public var isActive: Bool? { __data["isActive"] }
        public var account: Account? { __data["account"] }
        public var eClinics: [EClinic?]? { __data["eClinics"] }
        public var tags: [String?]? { __data["tags"] }

        /// AccountStaffLogin.Staff.Account
        ///
        /// Parent Type: `Account`
        public struct Account: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { API.Objects.Account }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("accountId", String?.self),
            .field("fullName", String?.self),
          ] }

          public var accountId: String? { __data["accountId"] }
          public var fullName: String? { __data["fullName"] }
        }

        /// AccountStaffLogin.Staff.EClinic
        ///
        /// Parent Type: `EClinic`
        public struct EClinic: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { API.Objects.EClinic }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("eClinicId", String?.self),
            .field("slug", String?.self),
            .field("displayName", String?.self),
          ] }

          public var eClinicId: String? { __data["eClinicId"] }
          public var slug: String? { __data["slug"] }
          public var displayName: String? { __data["displayName"] }
        }
      }
    }
  }
}
