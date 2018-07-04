/**
 * Registry.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package org.us_vo.www;

public interface Registry extends javax.xml.rpc.Service {
    public java.lang.String getRegistrySoapAddress();

    public org.us_vo.www.RegistrySoap getRegistrySoap() throws javax.xml.rpc.ServiceException;

    public org.us_vo.www.RegistrySoap getRegistrySoap(java.net.URL portAddress) throws javax.xml.rpc.ServiceException;
}
