import Foundation
import UIKit

// Image Processor class which can process an Image with infinite amount of filters :)
public class ImageProcessor {
    
    var image : UIImage?
    var originalImage : UIImage?
    private var previousImage : UIImage?
    private var imageRGBA : RGBAImage?
    var filters : [Filter]?

    var brightnessIntensity : Int = 0
    var contrastIntensity : Int = 0
    var redIntensity : Int = 0
    var greenIntensity : Int = 0
    var blueIntensity : Int = 0
    
    public init () {
        
    }
    public init (image : UIImage) {
        self.image = image
        self.originalImage = image
        self.previousImage = image
        self.imageRGBA = RGBAImage(image: self.image!, orientation: self.image!.imageOrientation)
    }
    
    public func process(filters : Filter...) -> UIImage {
        if self.filters != nil {
            self.filters?.appendContentsOf(filters)
        } else {
            self.filters = filters
        }
        self.imageRGBA = RGBAImage(image: self.image!, orientation: self.originalImage!.imageOrientation)
        for filter in filters {
            self.imageRGBA!.applyFilter(filter)
        }
        self.image = self.imageRGBA!.toUIImage()!
        return self.image!
    }
//    public func process(image: UIImage, filters : Filter...) -> UIImage {
//        self.image = image
//        self.imageRGBA = RGBAImage(image: self.image!)
//        self.filters!.appendContentsOf(filters)
//        for filter in filters {
//            self.imageRGBA!.applyFilter(filter)
//        }
//        self.image = self.imageRGBA!.toUIImage()!
//        return self.image!
//    }
    public func reset() {
        self.image = self.originalImage
        self.previousImage = self.originalImage
        self.imageRGBA = RGBAImage(image: self.originalImage!, orientation: (self.image?.imageOrientation)!)
        self.filters = nil
        self.brightnessIntensity = 0
        self.contrastIntensity = 0
        self.redIntensity = 0
        self.greenIntensity = 0
        self.blueIntensity = 0
    }
}