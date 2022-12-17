//
//  LocalFileManager.swift
//  CryptoManiac
//
//  Created by Joseph  DeWeese on 12/17/22.
//

import Foundation
import SwiftUI

class LocalFileManager {
    //PROPERTIES
    static let instance = LocalFileManager()
    private init( ) {  }
    
    //MARK:  SAVE IMAGE
    func saveImage( image: UIImage, imageName: String, folderName: String) {
        
        //CREATE FOLDER
        createFolderIfNeeded(folderName: folderName)
        
        //GET PATH FOR IMAGE
        guard
            let data = image.pngData( ),
            let url = getURLForImage(imageName: imageName, folderName: folderName)
        else {return}
        
        //SAVE IMAGE TO PATH
        do {
            try data.write(to: url)
            
        }catch let error {
            print("error saving image.  Image name:  \(error)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage?  {
        
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path)  else {
            return nil
        }
        return UIImage(contentsOfFile:  url.path)
    }
    
    private func createFolderIfNeeded(folderName: String)  {
        guard let url = getURLForFolder(folderName: folderName) else {return}
        
        ///if file does not exist...
        if !FileManager.default.fileExists(atPath: url.path) {
            do{
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            }catch let error {
                print("Error creating directory.  Folder Name:  \(folderName). \(error)")
                
            }
        }
    }
    private func getURLForFolder(folderName: String) ->  URL? {
        
      guard  let url = FileManager.default.urls(for: .cachesDirectory,  in:  .userDomainMask).first   else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL?  {
        guard let folderURL = getURLForFolder(folderName:  folderName)  else {
            return nil
        }
        return folderURL.appendingPathComponent(imageName + ".png")
    }
}
