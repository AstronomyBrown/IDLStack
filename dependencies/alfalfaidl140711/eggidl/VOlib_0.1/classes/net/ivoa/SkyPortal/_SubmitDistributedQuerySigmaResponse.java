/**
 * _SubmitDistributedQuerySigmaResponse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.SkyPortal;

public class _SubmitDistributedQuerySigmaResponse  implements java.io.Serializable {
    private net.ivoa.SkyPortal.VOData submitDistributedQuerySigmaResult;

    public _SubmitDistributedQuerySigmaResponse() {
    }


    /**
     * Gets the submitDistributedQuerySigmaResult value for this _SubmitDistributedQuerySigmaResponse.
     * 
     * @return submitDistributedQuerySigmaResult
     */
    public net.ivoa.SkyPortal.VOData getSubmitDistributedQuerySigmaResult() {
        return submitDistributedQuerySigmaResult;
    }


    /**
     * Sets the submitDistributedQuerySigmaResult value for this _SubmitDistributedQuerySigmaResponse.
     * 
     * @param submitDistributedQuerySigmaResult
     */
    public void setSubmitDistributedQuerySigmaResult(net.ivoa.SkyPortal.VOData submitDistributedQuerySigmaResult) {
        this.submitDistributedQuerySigmaResult = submitDistributedQuerySigmaResult;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof _SubmitDistributedQuerySigmaResponse)) return false;
        _SubmitDistributedQuerySigmaResponse other = (_SubmitDistributedQuerySigmaResponse) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.submitDistributedQuerySigmaResult==null && other.getSubmitDistributedQuerySigmaResult()==null) || 
             (this.submitDistributedQuerySigmaResult!=null &&
              this.submitDistributedQuerySigmaResult.equals(other.getSubmitDistributedQuerySigmaResult())));
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
        if (getSubmitDistributedQuerySigmaResult() != null) {
            _hashCode += getSubmitDistributedQuerySigmaResult().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(_SubmitDistributedQuerySigmaResponse.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">SubmitDistributedQuerySigmaResponse"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("submitDistributedQuerySigmaResult");
        elemField.setXmlName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "SubmitDistributedQuerySigmaResult"));
        elemField.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "VOData"));
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
