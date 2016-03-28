//
//  ViewController.swift
//  Philip's Filters
//
//  Created by Филипп Белов on 2/13/16.
//  Copyright © 2016 Philip Belov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageRGBA : RGBAImage?
    var imgPrcssr : ImageProcessor?
    var defaultImage : UIImage?
    var previousImage : UIImage?
    var topMenuConstraints : [NSLayoutConstraint]?
    var rgbMenuConstraints : [NSLayoutConstraint]?
    var filtersMenuConstraints : [NSLayoutConstraint]?
    var intensitySliderConstraints : [NSLayoutConstraint]?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filtersButton: UIButton!
    
    @IBOutlet var filtersMenu: UIView!
    @IBOutlet var rgbMenuContainer: UIStackView!
    @IBOutlet var rgbMenu: UIView!
    
    @IBOutlet var intensitySlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var redSlider: UISlider!
    
    @IBOutlet weak var bottomMenu: UIView!
    @IBOutlet weak var originalLabel: UILabel!
    @IBOutlet weak var duplicateImageView: UIImageView!

    
    @IBAction func onFilter(sender: UIButton) {
        showFiltersMenu()
    }
    
    @IBAction func onNewPhoto(sender: UIButton) {
        let actionSheet = UIAlertController(title: "Load New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Library", style: .Default, handler: { action in
            self.showLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: false, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showLibrary() {
        let libraryPicker = UIImagePickerController()
        libraryPicker.delegate = self
        libraryPicker.sourceType = .PhotoLibrary
        
        presentViewController(libraryPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let fixedImage = fixOrientation(image)
            imageView.image = fixedImage
            duplicateImageView.image = fixedImage
            imgPrcssr = ImageProcessor(image: fixedImage)
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onShare(sender: UIButton) {
        let activityController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    func showFiltersMenu() {
        view.addSubview(filtersMenu)
        
        let bottomConstraint = NSLayoutConstraint(item: filtersMenu, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        let leftConstraint = NSLayoutConstraint(item: filtersMenu, attribute:
            .Leading, relatedBy: .Equal, toItem: view,
            attribute: .Leading, multiplier: 1.0,
            constant: 0.0)
        let rightConstraint = NSLayoutConstraint(item: filtersMenu, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: filtersMenu, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        let heightConstraint = filtersMenu.heightAnchor.constraintEqualToConstant(50)
        filtersMenuConstraints = [leftConstraint, rightConstraint, bottomConstraint, topConstraint, heightConstraint]
        
        NSLayoutConstraint.activateConstraints([leftConstraint, rightConstraint, topConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.filtersMenu.alpha = 0.0
        
        UIView.animateWithDuration(0.5, delay: 0.05, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: {
            NSLayoutConstraint.deactivateConstraints([topConstraint])
            NSLayoutConstraint.activateConstraints([bottomConstraint])
            self.view.layoutIfNeeded()
            self.filtersMenu.alpha = 1.0
            }, completion: nil)
    }
    
//    func hideFiltersMenu() {
//        UIView.animateWithDuration(0.2, animations: {
//            self.filtersMenu.alpha = 0.0
//            self.intensitySlider.alpha = 0.0
//            self.rgbMenu.alpha = 0.0
//            }) { completed in
//                if completed {
//                    self.filtersMenu.removeFromSuperview()
//                    self.intensitySlider.removeFromSuperview()
//                    self.rgbMenu.removeFromSuperview()
//                }
//        }
//    }
    
    func showIntensitySlider(forFilter : FilterEnum) {
        print(forFilter)
        view.insertSubview(intensitySlider, belowSubview: filtersMenu)
        intensitySlider.value = 0.0
        
        let leftConstraint = NSLayoutConstraint(item: intensitySlider, attribute:
            .Leading, relatedBy: .Equal, toItem: view,
            attribute: .Leading, multiplier: 1.0,
            constant: 0)
        let rightConstraint = NSLayoutConstraint(item: intensitySlider, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: intensitySlider, attribute: .Bottom, relatedBy: .Equal, toItem: filtersMenu, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: intensitySlider, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        intensitySliderConstraints = [leftConstraint, rightConstraint, bottomConstraint, topConstraint]
        
        NSLayoutConstraint.activateConstraints([leftConstraint, rightConstraint, topConstraint])
        
        view.layoutIfNeeded()
        
        intensitySlider.alpha = 0.0
        
        UIView.animateWithDuration(0.5, delay: 0.05, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.7, options: .CurveEaseOut, animations: {
            NSLayoutConstraint.deactivateConstraints([topConstraint])
            NSLayoutConstraint.activateConstraints([bottomConstraint])
            self.view.layoutIfNeeded()
            self.intensitySlider.alpha = 1.0
            }, completion: {(finished : Bool) in
                self.intensitySlider.setValue(0.0, animated: false)
                switch forFilter {
                case .Brightness:
                    print("Brightness")
                    UIView.animateWithDuration(0.4, delay: 0.01, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.7, options: .CurveEaseOut, animations: {
                        self.intensitySlider.setValue(Float(self.imgPrcssr!.brightnessIntensity), animated: true)
                        }, completion:  nil)
                    break
                case .Contrast:
                    print("Contrast")
                    UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.7, options: .CurveEaseOut, animations: {
                        self.intensitySlider.setValue(Float(self.imgPrcssr!.contrastIntensity), animated: true)
                        }, completion:  nil)
                    break
                default:
                    break
                }
        })
    }
    
    func hideIntensitySlider() {
        UIView.animateWithDuration(0.2, animations: {
            self.intensitySlider.alpha = 0.0
            }) { completed in
                if completed {
                    self.intensitySlider.removeFromSuperview()
                }
        }
    }
    
    func showRGBSliders() {
        rgbMenu.alpha = 0.0
        redSlider.value = 0.0
        greenSlider.value = 0.0
        blueSlider.value = 0.0

        view.insertSubview(rgbMenu, belowSubview: filtersMenu)
        
        let leftConstraint = NSLayoutConstraint(item: rgbMenu, attribute:
            .Leading, relatedBy: .Equal, toItem: view,
            attribute: .Leading, multiplier: 1.0,
            constant: 0)
        let rightConstraint = NSLayoutConstraint(item: rgbMenu, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: rgbMenu, attribute: .Bottom, relatedBy: .Equal, toItem: filtersMenu, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: rgbMenu, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        rgbMenuConstraints = [leftConstraint, rightConstraint, bottomConstraint, topConstraint]
        let redSliderBottomConstraint = NSLayoutConstraint(item: redSlider, attribute: .Bottom, relatedBy: .Equal, toItem: greenSlider, attribute: .Top, multiplier: 1.0, constant: -14.0)
        let greenSliderBottomConstraint = NSLayoutConstraint(item: greenSlider, attribute: .Bottom, relatedBy: .Equal, toItem: blueSlider, attribute: .Top, multiplier: 1.0, constant: -14.0)
        let blueSliderBottomConstraint = NSLayoutConstraint(item: blueSlider, attribute: .Bottom, relatedBy: .Equal, toItem: rgbMenu, attribute: .Bottom, multiplier: 1.0, constant: -14.0)
        
        NSLayoutConstraint.activateConstraints([rgbMenuConstraints![0], rgbMenuConstraints![1], rgbMenuConstraints![3], redSliderBottomConstraint, greenSliderBottomConstraint, blueSliderBottomConstraint])
        
        view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.5, delay: 0.05, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.7, options: .CurveEaseOut, animations: {
            NSLayoutConstraint.deactivateConstraints([topConstraint])
            NSLayoutConstraint.activateConstraints([bottomConstraint])
            
            self.view.layoutIfNeeded()
            self.rgbMenu.alpha = 1.0
            }, completion: {(finished : Bool) in
                if finished {

                    UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: .CurveEaseOut, animations: {
                    self.redSlider.setValue(Float((self.imgPrcssr?.redIntensity)!), animated: true)
                    self.greenSlider.setValue(Float((self.imgPrcssr?.greenIntensity)!), animated: true)
                    self.blueSlider.setValue(Float((self.imgPrcssr?.blueIntensity)!), animated: true)
                    }, completion: nil)
                }
        })
    }
    
    @IBAction func applyBrightnessFilter(sender: UIButton) {
        self.rgbMenu.removeFromSuperview()
        self.intensitySlider.removeFromSuperview()
        showIntensitySlider(.Brightness)
        previousImage = imageView.image
        intensitySlider.removeTarget(self, action: "updateImageContrast", forControlEvents: .TouchUpInside)
        intensitySlider.addTarget(self, action: "updateImageBrightness", forControlEvents: .TouchUpInside)
    }
    
    func updateImageBrightness() {
        let deltaBrightness = Int(intensitySlider.value) - (imgPrcssr?.brightnessIntensity)!
        updateImage((imgPrcssr?.process(Brightness(intensity: deltaBrightness)))!)
        imgPrcssr?.brightnessIntensity = Int(intensitySlider.value)
    }
    
    @IBAction func applyContrastFilter(sender: UIButton) {
        self.rgbMenu.removeFromSuperview()
        self.intensitySlider.removeFromSuperview()
        showIntensitySlider(.Contrast)
        previousImage = imageView.image
        intensitySlider.removeTarget(self, action: "updateImageBrightness", forControlEvents: .TouchUpInside)
        intensitySlider.addTarget(self, action: "updateImageContrast", forControlEvents: .TouchUpInside)
    }
    
    func updateImageContrast() {
        let deltaContrast = Int(intensitySlider.value) - (imgPrcssr?.contrastIntensity)!
        updateImage((imgPrcssr?.process(Contrast(intensity: deltaContrast)))!)
        imgPrcssr?.contrastIntensity = Int(intensitySlider.value)
    }
    
    @IBAction func applyGrayscaleFilter(sender: UIButton) {
        self.rgbMenu.removeFromSuperview()
        self.intensitySlider.removeFromSuperview()
        previousImage = imageView.image
        updateImage((imgPrcssr?.process(Grayscale()))!)
    }
    
    @IBAction func applyRGBFilter(sender: UIButton) {
        self.rgbMenu.removeFromSuperview()
        self.intensitySlider.removeFromSuperview()
        showRGBSliders()
        previousImage = imageView.image
        print(redSlider.value, greenSlider.value, blueSlider.value)
        redSlider.addTarget(self, action: "updateRedChannel", forControlEvents: .TouchUpInside)
        greenSlider.addTarget(self, action: "updateGreenChannel", forControlEvents: .TouchUpInside)
        blueSlider.addTarget(self, action: "updateBlueChannel", forControlEvents: .TouchUpInside)
    }
    
    func updateRedChannel() {
        //imgPrcssr?.image = previousImage
        //updateImage((imgPrcssr?.process(ColorBalance(intensity: Int(redSlider.value), channel: .Red)))!)
        let deltaRed = Int(redSlider.value) - (imgPrcssr?.redIntensity)!
        updateImage((imgPrcssr?.process(ColorBalance(intensity: deltaRed, channel: .Blue)))!)
        imgPrcssr?.redIntensity = Int(redSlider.value)
    }
    
    func updateGreenChannel() {
        //imgPrcssr?.image = previousImage
        let deltaGreen = Int(greenSlider.value) - (imgPrcssr?.greenIntensity)!
        updateImage((imgPrcssr?.process(ColorBalance(intensity: deltaGreen, channel: .Green)))!)
        imgPrcssr?.greenIntensity = Int(greenSlider.value)
    }

    func updateBlueChannel() {
        //imgPrcssr?.image = previousImage
        let deltaBlue = Int(blueSlider.value) - (imgPrcssr?.blueIntensity)!
        updateImage((imgPrcssr?.process(ColorBalance(intensity: deltaBlue, channel: .Blue)))!)
        imgPrcssr?.blueIntensity = Int(blueSlider.value)
    }
    
    func updateImage(image: UIImage) {
        duplicateImageView.alpha = 0.0
        duplicateImageView.image = image
        UIView.animateWithDuration(0.5, delay: 0.05, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.7, options: .CurveEaseOut, animations: {
            self.duplicateImageView.alpha = 1.0
            }) { completed in
                if completed {
                    self.imageView.image = image
                    self.duplicateImageView.alpha = 0.0
                    self.duplicateImageView.image = self.imgPrcssr!.originalImage
                }
        }
    }
    
    @IBAction func resetImage(sender: UIButton) {
        imgPrcssr?.reset()
        updateImage((imgPrcssr?.image)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultImage = imageView.image
        imgPrcssr = ImageProcessor(image: imageView.image!)
        duplicateImageView.image = imgPrcssr?.image
        
        filtersMenu.translatesAutoresizingMaskIntoConstraints = false
        intensitySlider.translatesAutoresizingMaskIntoConstraints = false
        rgbMenu.translatesAutoresizingMaskIntoConstraints = false
        
        var sliderFrame : CGRect = self.intensitySlider.frame;
        sliderFrame.size.height = 142.0;
        self.intensitySlider.frame = sliderFrame

    }
    
    @IBAction func imagePressed(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            UIView.animateWithDuration(0.5, delay: 0.05, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .CurveEaseOut, animations: {
                    self.duplicateImageView.alpha = 1.0
                    self.originalLabel.alpha = 1.0
                }, completion: nil)
        }
        if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.2, animations: {
                self.duplicateImageView.alpha = 0.0
                self.originalLabel.alpha = 0.0
            })
            imageView.image = imgPrcssr?.image
        }
        
    }
    
    @IBAction func didSwipeDown(sender: UISwipeGestureRecognizer) {
        if (self.view.subviews.contains(intensitySlider)) {
            UIView.animateWithDuration(0.5, delay: 0.05, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.7, options: .CurveEaseOut, animations: {
                
                NSLayoutConstraint.deactivateConstraints([self.intensitySliderConstraints![2]])
                NSLayoutConstraint.activateConstraints([self.intensitySliderConstraints![3]])
                NSLayoutConstraint.deactivateConstraints([self.filtersMenuConstraints![2]])
                NSLayoutConstraint.activateConstraints([self.filtersMenuConstraints![3]])
                self.view.layoutIfNeeded()
                }, completion: {(completed : Bool) in
                    self.filtersMenu.removeFromSuperview()
                    self.intensitySlider.removeFromSuperview()
                    NSLayoutConstraint.deactivateConstraints(self.intensitySliderConstraints!)
                    NSLayoutConstraint.deactivateConstraints(self.filtersMenuConstraints!)
                    self.view.layoutIfNeeded()
            })
        } else if (self.view.subviews.contains(rgbMenu)) {
            UIView.animateWithDuration(0.5, delay: 0.05, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.7, options: .CurveEaseOut, animations: {
                NSLayoutConstraint.deactivateConstraints([self.rgbMenuConstraints![2]])
                NSLayoutConstraint.activateConstraints([self.rgbMenuConstraints![3]])
                NSLayoutConstraint.deactivateConstraints([self.filtersMenuConstraints![2]])
                NSLayoutConstraint.activateConstraints([self.filtersMenuConstraints![3]])
                self.view.layoutIfNeeded()
                }, completion: {(completed : Bool) in
                    self.filtersMenu.removeFromSuperview()
                    self.rgbMenu.removeFromSuperview()
                    NSLayoutConstraint.deactivateConstraints(self.rgbMenuConstraints!)
                    NSLayoutConstraint.deactivateConstraints(self.filtersMenuConstraints!)
                    self.view.layoutIfNeeded()
            })
        } else if (self.view.subviews.contains(filtersMenu)) {
            UIView.animateWithDuration(0.5, delay: 0.05, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.7, options: .CurveEaseOut, animations: {
                NSLayoutConstraint.deactivateConstraints([self.filtersMenuConstraints![2]])
                NSLayoutConstraint.activateConstraints([self.filtersMenuConstraints![3]])
                        self.view.layoutIfNeeded()
                }, completion: {(completed : Bool) in
                    self.filtersMenu.removeFromSuperview()
                    NSLayoutConstraint.deactivateConstraints(self.filtersMenuConstraints!)
                    self.view.layoutIfNeeded()
            })
            filtersButton.selected = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

