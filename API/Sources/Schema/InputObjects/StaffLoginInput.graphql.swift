// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct StaffLoginInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    username: GraphQLNullable<String> = nil,
    password: GraphQLNullable<String> = nil
  ) {
    __data = InputDict([
      "username": username,
      "password": password
    ])
  }

  public var username: GraphQLNullable<String> {
    get { __data["username"] }
    set { __data["username"] = newValue }
  }

  public var password: GraphQLNullable<String> {
    get { __data["password"] }
    set { __data["password"] = newValue }
  }
}
