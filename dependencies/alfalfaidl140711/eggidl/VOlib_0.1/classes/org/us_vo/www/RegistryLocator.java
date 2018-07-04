/**
 * RegistryLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package org.us_vo.www;

public class RegistryLocator extends org.apache.axis.client.Service implements org.us_vo.www.Registry {

    // Use to get a proxy class for RegistrySoap
    private java.lang.String RegistrySoap_address = "http://voservices.net/Registry/registry.asmx";

    public java.lang.String getRegistrySoapAddress() {
        return RegistrySoap_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String RegistrySoapWSDDServiceName = "RegistrySoap";

    public java.lang.String getRegistrySoapWSDDServiceName() {
        return RegistrySoapWSDDServiceName;
    }

    public void setRegistrySoapWSDDServiceName(java.lang.String name) {
        RegistrySoapWSDDServiceName = name;
    }

    public org.us_vo.www.RegistrySoap getRegistrySoap() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(RegistrySoap_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getRegistrySoap(endpoint);
    }

    public org.us_vo.www.RegistrySoap getRegistrySoap(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            org.us_vo.www.RegistrySoapStub _stub = new org.us_vo.www.RegistrySoapStub(portAddress, this);
            _stub.setPortName(getRegistrySoapWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setRegistrySoapEndpointAddress(java.lang.String address) {
        RegistrySoap_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (org.us_vo.www.RegistrySoap.class.isAssignableFrom(serviceEndpointInterface)) {
                org.us_vo.www.RegistrySoapStub _stub = new org.us_vo.www.RegistrySoapStub(new java.net.URL(RegistrySoap_address), this);
                _stub.setPortName(getRegistrySoapWSDDServiceName());
                return _stub;
            }
        }
        catch (java.lang.Throwable t) {
            throw new javax.xml.rpc.ServiceException(t);
        }
        throw new javax.xml.rpc.ServiceException("There is no stub implementation for the interface:  " + (serviceEndpointInterface == null ? "null" : serviceEndpointInterface.getName()));
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(javax.xml.namespace.QName portName, Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        if (portName == null) {
            return getPort(serviceEndpointInterface);
        }
        String inputPortName = portName.getLocalPart();
        if ("RegistrySoap".equals(inputPortName)) {
            return getRegistrySoap();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://www.us-vo.org", "Registry");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("RegistrySoap"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        if ("RegistrySoap".equals(portName)) {
            setRegistrySoapEndpointAddress(address);
        }
        else { // Unknown Port Name
            throw new javax.xml.rpc.ServiceException(" Cannot set Endpoint Address for Unknown Port" + portName);
        }
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(javax.xml.namespace.QName portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        setEndpointAddress(portName.getLocalPart(), address);
    }

}
