package com.cloud.beans;
import org.springframework.web.multipart.MultipartFile;

public class ImageUpload 
{
	private String name;
	private MultipartFile fileData;
	public String getName() {
		return name;
	}
	public MultipartFile getFileData() {
		return fileData;
	}
	public void setName(String name) {
		this.name = name;
	}
	public void setFileData(MultipartFile fileData) {
		this.fileData = fileData;
	}
	
}