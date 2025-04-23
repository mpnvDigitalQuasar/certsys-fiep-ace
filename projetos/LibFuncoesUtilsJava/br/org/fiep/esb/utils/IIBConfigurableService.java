package br.org.fiep.esb.utils;


public class IIBConfigurableService {
	
	private String name;
	private String dataCaptureStore;
	private String topic;
	
	
	public String getDataCaptureStore() {
		return dataCaptureStore;
	}
	public void setDataCaptureStore(String dataCaptureStore) {
		this.dataCaptureStore = dataCaptureStore;
	}
	public String getTopic() {
		return topic;
	}
	public void setTopic(String topic) {
		this.topic = topic;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
}
