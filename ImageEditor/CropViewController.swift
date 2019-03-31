import UIKit


class CropViewController: UIViewController, UIScrollViewDelegate {
    
    var initialImage: UIImage?
    var delegate: ProfileViewControllerProtocol?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cropImage: UIImageView!
    @IBOutlet weak var gridImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.delegate = self
        
        self.scrollView.decelerationRate = .fast
        
        self.cropImage.image = self.initialImage
        
        self.setupInitialZoomScale()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.centerScrollViewContents()
    }
    
    
    // MARK: Actions
    
    @IBAction func onUseImageTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: {
            
            let gridToImage = self.gridImage.convert(self.gridImage.bounds, to: self.cropImage)
            
            let croppedImage = self.cropImage.snapshot(of: gridToImage)
            
            self.delegate?.setCroppedImage(croppedImage)
        })
    }
    
    
    @IBAction func onCancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Scroll Delegate Method

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return cropImage
    }
    
    
    // MARK: Private Methods
    
    private func setupInitialZoomScale() {
        let scrollSize = self.scrollView.bounds.size
        
        if let imagesize = self.cropImage.image?.size {
            
            let widthRatio = scrollSize.width / imagesize.width
            let heightRatio = scrollSize.height / imagesize.height
            
            let minZoom = max(widthRatio, heightRatio)
            
            self.scrollView.minimumZoomScale = minZoom
            self.scrollView.zoomScale = minZoom
        }
    }
    
    
    private func centerScrollViewContents() {
        
        let frameHeight = self.cropImage.frame.size.height
        let frameWidth = self.cropImage.frame.size.width
        
        var point = CGPoint()
        
        if frameHeight < frameWidth {
            
            point.x = (frameWidth - self.scrollView.bounds.width)/2
        } else {
            
            point.y = (frameHeight - self.scrollView.bounds.height)/2
        }
        
        self.scrollView.setContentOffset(point, animated: false)
        self.scrollView.contentInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
    }
}
