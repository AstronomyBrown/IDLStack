/**
 * SkyPortalLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.SkyPortal;

public class SkyPortalLocator extends org.apache.axis.client.Service implements net.ivoa.SkyPortal.SkyPortal {

    // Use to get a proxy class for SkyPortalSoap
    private java.lang.String SkyPortalSoap_address = "http://dev.openskyquery.net/Sky/SkyPortal/SkyPortal.asmx";

    public java.lang.String getSkyPortalSoapAddress() {
        return SkyPortalSoap_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String SkyPortalSoapWSDDServiceName = "SkyPortalSoap";

    public java.lang.String getSkyPortalSoapWSDDServiceName() {
        return SkyPortalSoapWSDDServiceName;
    }

    public void setSkyPortalSoapWSDDServiceName(java.lang.String name) {
        SkyPortalSoapWSDDServiceName = name;
    }

    public net.ivoa.SkyPortal.SkyPortalSoap getSkyPortalSoap() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(SkyPortalSoap_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getSkyPortalSoap(endpoint);
    }

    public net.ivoa.SkyPortal.SkyPortalSoap getSkyPortalSoap(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            net.ivoa.SkyPortal.SkyPortalSoapStub _stub = new net.ivoa.SkyPortal.SkyPortalSoapStub(portAddress, this);
            _stub.setPortName(getSkyPortalSoapWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setSkyPortalSoapEndpointAddress(java.lang.String address) {
        SkyPortalSoap_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (net.ivoa.SkyPortal.SkyPortalSoap.class.isAssignableFrom(serviceEndpointInterface)) {
                net.ivoa.SkyPortal.SkyPortalSoapStub _stub = new net.ivoa.SkyPortal.SkyPortalSoapStub(new java.net.URL(SkyPortalSoap_address), this);
                _stub.setPortName(getSkyPortalSoapWSDDServiceName());
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
        if ("SkyPortalSoap".equals(inputPortName)) {
            return getSkyPortalSoap();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("SkyPortal.ivoa.net", "SkyPortal");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("SkyPortalSoap"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        if ("SkyPortalSoap".equals(portName)) {
            setSkyPortalSoapEndpointAddress(address);
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
