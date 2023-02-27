//
//  LoginViewController.swift
//  Project_graduate
//
//  Created by 이혜인 on 2023/02/25.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

class LoginViewController: UIViewController {
    
    @IBOutlet weak var kakaoBtn: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGestureRecongnizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 유효한 토큰 검사
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        //로그인 필요
                    }
                    else {
                        //기타 에러
                    }
                }
                else {
                    // 토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    // 사용자 정보 가져오고 화면 전환하는 메소드
                    self.getUserInfo()
                }
            }
        }
        else {
            //로그인 필요
        }
    }
}

extension LoginViewController {
    private func setGestureRecongnizer(){
        let loginKakao = UITapGestureRecognizer(target: self, action: #selector(loginKakao))
        kakaoBtn.isUserInteractionEnabled = true
        kakaoBtn.addGestureRecognizer(loginKakao)
    }
    
    private func getUserInfo(){
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                
                //do something
                _ = user
//                let nickname = user?.kakaoAccount?.profile?.nickname
                
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MainPageViewController") as? MainPageViewController else {return}
                
//                nextVC.nickname = nickname
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            }
        }
    }
    
    @objc
    func loginKakao(){
        print("LoginViewController - loginKakao() called")
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    //do something
                    _ = oauthToken
                    self.getUserInfo()
                }
            }
        } else { // 카카오톡 설치X
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("loginWithKakaoAccount() success.")
                        //do something
                        _ = oauthToken
                        self.getUserInfo()
                    }
                }
        }
    }
}
