/**
 * SkyPortal.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.SkyPortal;

public interface SkyPortal extends javax.xml.rpc.Service {
    public java.lang.String getSkyPortalSoapAddress();

    public net.ivoa.SkyPortal.SkyPortalSoap getSkyPortalSoap() throws javax.xml.rpc.ServiceException;

    public net.ivoa.SkyPortal.SkyPortalSoap getSkyPortalSoap(java.net.URL portAddress) throws javax.xml.rpc.ServiceException;
}
