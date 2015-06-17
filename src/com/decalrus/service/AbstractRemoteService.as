package com.decalrus.service
{
	import mx.rpc.remoting.RemoteObject;
	
	import org.robotlegs.mvcs.Actor;

	public class AbstractRemoteService extends Actor
	{
		protected var remoteObject:RemoteObject;
		
		public function AbstractRemoteService(source:String, endpoint:String="/api/amf", destination:String="zend")
		{
			this.remoteObject = new RemoteObject();
			this.remoteObject.endpoint = endpoint; 
			this.remoteObject.source = source; 
			this.remoteObject.destination = destination;
		}
	}
}
