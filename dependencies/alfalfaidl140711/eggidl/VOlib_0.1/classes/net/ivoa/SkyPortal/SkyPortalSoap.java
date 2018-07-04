/**
 * SkyPortalSoap.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.SkyPortal;

public interface SkyPortalSoap extends java.rmi.Remote {

    /**
     * Executes a plan and returns results.
     */
    public net.ivoa.SkyPortal.VOData submitPlan(net.ivoa.SkyPortal.ExecPlan submitPlanEp) throws java.rmi.RemoteException;

    /**
     * Creates an ExecPlan.  This runs cost queries as well. (req.
     * for correct plan ordering)
     */
    public net.ivoa.SkyPortal.ExecPlan makePlan(java.lang.String makePlanQry, long makePlanPlanid, java.lang.String makePlanOutputType) throws java.rmi.RemoteException;

    /**
     * Runs a distributed query query by making a plan and then executing
     * it - you may call the two steps seperately if you wish to view the
     * plan or track progress.
     */
    public net.ivoa.SkyPortal.VOData submitDistributedQuery(java.lang.String submitDistributedQueryQry, java.lang.String submitDistributedQueryOutputType) throws java.rmi.RemoteException;

    /**
     * Allows MyData Sigma
     */
    public net.ivoa.SkyPortal.VOData submitDistributedQuerySigma(java.lang.String submitDistributedQuerySigmaQry, java.lang.String submitDistributedQuerySigmaOutputType, double submitDistributedQuerySigmaMyDataSigma) throws java.rmi.RemoteException;

    /**
     * Runs a single node query.
     */
    public net.ivoa.SkyPortal.VOData submitQuery(java.lang.String submitQueryQry, java.lang.String submitQueryNode, java.lang.String submitQueryFormat) throws java.rmi.RemoteException;

    /**
     * Lists names of all available node shortnames in a votable.
     */
    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.VOTABLE getAllSkyNodesVOTable() throws java.rmi.RemoteException;

    /**
     * Lists names of all available node shortnames.
     */
    public net.ivoa.SkyPortal.__GetAllSkyNodesResponse_GetAllSkyNodesResult getAllSkyNodes() throws java.rmi.RemoteException;

    /**
     * Returns tables.
     */
    public net.ivoa.SkyPortal.ArrayOfMetaTable getTables(java.lang.String getTablesNode) throws java.rmi.RemoteException;

    /**
     * Returns an array of column info.
     */
    public net.ivoa.SkyPortal.ArrayOfMetaColumn getMetaColumns(java.lang.String getMetaColumnsNode, java.lang.String getMetaColumnsTable) throws java.rmi.RemoteException;
    public boolean nodeContainsColumn(java.lang.String nodeContainsColumnNode, java.lang.String nodeContainsColumnTable, java.lang.String nodeContainsColumnColumn) throws java.rmi.RemoteException;

    /**
     * Returns literal table name
     */
    public java.lang.String uploadTable(net.ivoa.SkyPortal.VOData uploadTableData, int uploadTableFormat) throws java.rmi.RemoteException;

    /**
     * Returns an array of column names.
     */
    public net.ivoa.SkyPortal.ArrayOfString getColumns(java.lang.String getColumnsNode, java.lang.String getColumnsTable) throws java.rmi.RemoteException;

    /**
     * Returns column info for one column.
     */
    public net.ivoa.SkyPortal.MetaTable getTableInfo(java.lang.String getTableInfoNode, java.lang.String getTableInfoTable) throws java.rmi.RemoteException;

    /**
     * Returns column info for one column.
     */
    public net.ivoa.SkyPortal.ArrayOfMetaTable getMetaTables(java.lang.String getMetaTablesNode) throws java.rmi.RemoteException;

    /**
     * Returns column info for one column.
     */
    public net.ivoa.SkyPortal.MetaColumn getColumnInfo(java.lang.String getColumnInfoNode, java.lang.String getColumnInfoTable, java.lang.String getColumnInfoColumn) throws java.rmi.RemoteException;
}
