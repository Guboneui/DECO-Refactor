//
//  LoginComponent.swift
//  Login
//
//  Created by 구본의 on 2023/04/23.
//

import RIBs

public class LoginComponent: Component<EmptyDependency>, LoginMainDependency {
  public init() {
    super.init(dependency: EmptyComponent())
  }
}
