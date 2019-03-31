import UIKit


protocol ProfileViewControllerProtocol {
    func setCroppedImage(_ croppedImage: UIImage)
}


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProfileViewControllerProtocol {

    @IBOutlet weak var profileImageView: UIImageView!
    
    let cropSegue = "profileToCropSegue"
    var chosenImage: UIImage?
    lazy var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupImageView()
    }

    
    func setCroppedImage(_ croppedImage: UIImage) {
        self.profileImageView.image = croppedImage
    }
    
    
    @IBAction func onAddImageTapped(_ sender: Any) {
        self.imagePicker.delegate = self

        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhoto = UIAlertAction.init(
            title: "Take Photo",
            style: .default,
            handler: { (UIAlertAction) -> Void in
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            })
        
        let choosePhotoAction = UIAlertAction.init(
            title: "Open Library",
            style: .default,
            handler: { (UIAlertAction) -> Void in
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            })
        
        let cancel = UIAlertAction.init(title: "Cancel",
                                        style: .cancel,
                                        handler: nil)
        
        alert.addAction(takePhoto)
        alert.addAction(choosePhotoAction)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        self.chosenImage = info[.originalImage] as? UIImage
                
        self.dismiss(animated: false, completion: {
            self.performSegue(withIdentifier: self.cropSegue, sender: nil)
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cropViewController = segue.destination as? CropViewController,
            segue.identifier == self.cropSegue {
            cropViewController.initialImage = self.chosenImage
            cropViewController.delegate = self
        }
    }
    
    
    // MARK Private methods
    
    private func setupImageView() {
        
        self.profileImageView.layer.borderWidth = 2
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2.0;
        self.profileImageView.layer.masksToBounds = true
    }
}

