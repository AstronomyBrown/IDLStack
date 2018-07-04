/**
 * RegistrySoap.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package org.us_vo.www;

public interface RegistrySoap extends java.rmi.Remote {

    /**
     * Retrieve All Records from Registry, returns SimpleResources
     */
    public org.us_vo.www.ArrayOfSimpleResource dumpRegistry() throws java.rmi.RemoteException;

    /**
     * Retrieve All VOResources from Registry
     */
    public net.ivoa.www.xml.VOResource.v0_10.ArrayOfResource dumpVOResources() throws java.rmi.RemoteException;

    /**
     * Returns VOResources: Input WHERE predicate for SQL Query like
     * e.g. 
     *  maxSearchRadius > 1 and ResourceType like 'CONE'
     */
    public net.ivoa.www.xml.VOResource.v0_10.ArrayOfResource queryVOResource(java.lang.String queryVOResourcePredicate) throws java.rmi.RemoteException;

    /**
     * Returns custom simplified Resources: Input WHERE predicate
     * for SQL Query like e.g. 
     *  ResourceType like 'CONE'
     */
    public org.us_vo.www.ArrayOfDBResource queryResource(java.lang.String queryResourcePredicate) throws java.rmi.RemoteException;

    /**
     * Returns SimpleResource (backward compatibility for DATASCOPE):
     * Input WHERE predicate for SQL Query like e.g. 
     *  maxSearchRadius > 1 and ResourceType like 'CONE'
     */
    public org.us_vo.www.ArrayOfSimpleResource queryRegistry(java.lang.String queryRegistryPredicate) throws java.rmi.RemoteException;

    /**
     * searches registry for keyword
     */
    public net.ivoa.www.xml.VOResource.v0_10.ArrayOfResource keywordSearch(java.lang.String keywordSearchKeywords, boolean keywordSearchAndKeys) throws java.rmi.RemoteException;

    /**
     * returns cvs verions of classes in this service
     */
    public org.us_vo.www.ArrayOfString revisions() throws java.rmi.RemoteException;
}
