//
//  CamViewController.swift
//  Project_graduate
//
//  Created by 윤한솔 on 2023/01/04.
//

import UIKit
import CropViewController
import Alamofire

class CamViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, CropViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        //안되면 mainpage 버튼으로 넘기기
        let camera = UIImagePickerController()
        camera.sourceType = .camera
        camera.allowsEditing = false
        camera.cameraDevice = .rear
        camera.cameraCaptureMode = .photo
        camera.delegate = self
        present(camera, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.navigationController?.popViewController(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        picker.dismiss(animated: true)
        showCrop(image:image)
    }
    
    func showCrop(image : UIImage) {
        let vc = CropViewController(croppingStyle: .default, image: image)
        vc.aspectRatioPreset = .presetSquare
        vc.aspectRatioLockEnabled = false
        vc.doneButtonColor = .systemRed
        vc.cancelButtonColor = .systemRed
        vc.toolbarPosition = .bottom
        vc.doneButtonTitle = "Continue"
        vc.cancelButtonTitle = "Quit"
        vc.delegate = self
        present(vc, animated:true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage,withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true)
        
        let imageVIEW = UIImageView(frame: view.frame)
        imageVIEW.contentMode = .scaleAspectFit
        imageVIEW.image = image
        view.addSubview(imageVIEW)
        //image 파일 업로드하기
        uploadImage(image: image)
        
        guard let newVC = self.storyboard?.instantiateViewController(withIdentifier:"TitleListViewController") as? TitleListViewController else {
            return
        }
        //네비게이션 뷰 스택에서 크롭 뷰 팝하는 코드
        if let navigationController = navigationController {
            var viewControllers = navigationController.viewControllers
            if let cropViewControllerIndex = viewControllers.firstIndex(where: {$0 is CropViewController}){
                viewControllers.remove(at: cropViewControllerIndex)
                navigationController.setViewControllers(viewControllers, animated: false)
            }
        }
        self.navigationController?.pushViewController(newVC, animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
    // upload 함수, or af.request(url, method:.post), param : -> image
    func uploadImage(image: UIImage) {
        let url : String = "http://3.39.106.142:8000/api/"
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(image.jpegData(compressionQuality: 1.0 )!, withName: "image", fileName: "photo.jpeg", mimeType: "image/jpg")
        }, to: url, method: .post, headers: ["Content-Type" : "multipart/form-data"])
        .response { (response) in
            if response.error != nil {
                //파일 업로드 실패
                print(AFError.self)
            } else {
                //파일 업로드 성공
                print("File Upload success")
            }
        }//key image , value file.jpeg
    }
   
    @IBAction func onBtn(_ sender: UIBarButtonItem) {
        func viewWillAppear(_ animated: Bool) {
            let camera = UIImagePickerController()
            camera.sourceType = .camera
            camera.allowsEditing = false
            camera.cameraDevice = .rear
            camera.cameraCaptureMode = .photo
            camera.delegate = self
            present(camera, animated: true, completion: nil)
        }
        viewWillAppear(true)
    }
}
