import Foundation
import UIKit

// I decided to create a 'clamping' function for easier assigning values to the pixel components
func clamp(value: Int) -> UInt8 {
    return UInt8(max(0, min(255, value)))
}

func fixOrientation(img:UIImage) -> UIImage {
    
    if (img.imageOrientation == UIImageOrientation.Up) {
        return img;
    }
    
    UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
    let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
    img.drawInRect(rect)
    
    let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext();
    return normalizedImage;
    
}