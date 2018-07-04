/**
 * _GetAllSkyNodesResponse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.SkyPortal;

public class _GetAllSkyNodesResponse  implements java.io.Serializable {
    private net.ivoa.SkyPortal.__GetAllSkyNodesResponse_GetAllSkyNodesResult getAllSkyNodesResult;

    public _GetAllSkyNodesResponse() {
    }


    /**
     * Gets the getAllSkyNodesResult value for this _GetAllSkyNodesResponse.
     * 
     * @return getAllSkyNodesResult
     */
    public net.ivoa.SkyPortal.__GetAllSkyNodesResponse_GetAllSkyNodesResult getGetAllSkyNodesResult() {
        return getAllSkyNodesResult;
    }


    /**
     * Sets the getAllSkyNodesResult value for this _GetAllSkyNodesResponse.
     * 
     * @param getAllSkyNodesResult
     */
    public void setGetAllSkyNodesResult(net.ivoa.SkyPortal.__GetAllSkyNodesResponse_GetAllSkyNodesResult getAllSkyNodesResult) {
        this.getAllSkyNodesResult = getAllSkyNodesResult;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof _GetAllSkyNodesResponse)) return false;
        _GetAllSkyNodesResponse other = (_GetAllSkyNodesResponse) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.getAllSkyNodesResult==null && other.getGetAllSkyNodesResult()==null) || 
             (this.getAllSkyNodesResult!=null &&
              this.getAllSkyNodesResult.equals(other.getGetAllSkyNodesResult())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        if (getGetAllSkyNodesResult() != null) {
            _hashCode += getGetAllSkyNodesResult().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(_GetAllSkyNodesResponse.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetAllSkyNodesResponse"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("getAllSkyNodesResult");
        elemField.setXmlName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "GetAllSkyNodesResult"));
        elemField.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">>GetAllSkyNodesResponse>GetAllSkyNodesResult"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
