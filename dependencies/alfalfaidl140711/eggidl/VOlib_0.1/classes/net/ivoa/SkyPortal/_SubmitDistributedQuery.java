/**
 * _SubmitDistributedQuery.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.SkyPortal;

public class _SubmitDistributedQuery  implements java.io.Serializable {
    private java.lang.String qry;
    private java.lang.String outputType;

    public _SubmitDistributedQuery() {
    }


    /**
     * Gets the qry value for this _SubmitDistributedQuery.
     * 
     * @return qry
     */
    public java.lang.String getQry() {
        return qry;
    }


    /**
     * Sets the qry value for this _SubmitDistributedQuery.
     * 
     * @param qry
     */
    public void setQry(java.lang.String qry) {
        this.qry = qry;
    }


    /**
     * Gets the outputType value for this _SubmitDistributedQuery.
     * 
     * @return outputType
     */
    public java.lang.String getOutputType() {
        return outputType;
    }


    /**
     * Sets the outputType value for this _SubmitDistributedQuery.
     * 
     * @param outputType
     */
    public void setOutputType(java.lang.String outputType) {
        this.outputType = outputType;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof _SubmitDistributedQuery)) return false;
        _SubmitDistributedQuery other = (_SubmitDistributedQuery) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.qry==null && other.getQry()==null) || 
             (this.qry!=null &&
              this.qry.equals(other.getQry()))) &&
            ((this.outputType==null && other.getOutputType()==null) || 
             (this.outputType!=null &&
              this.outputType.equals(other.getOutputType())));
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
        if (getQry() != null) {
            _hashCode += getQry().hashCode();
        }
        if (getOutputType() != null) {
            _hashCode += getOutputType().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(_SubmitDistributedQuery.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">SubmitDistributedQuery"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("qry");
        elemField.setXmlName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "qry"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("outputType");
        elemField.setXmlName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "outputType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
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
