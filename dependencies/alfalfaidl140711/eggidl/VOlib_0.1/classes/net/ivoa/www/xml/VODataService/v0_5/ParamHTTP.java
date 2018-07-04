/**
 * ParamHTTP.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.VODataService.v0_5;

public class ParamHTTP  extends net.ivoa.www.xml.VOResource.v0_10._interface  implements java.io.Serializable {
    private java.lang.String resultType;
    private net.ivoa.www.xml.VODataService.v0_5.Param[] param;
    private net.ivoa.www.xml.VODataService.v0_5.HTTPQueryType qtype;  // attribute

    public ParamHTTP() {
    }


    /**
     * Gets the resultType value for this ParamHTTP.
     * 
     * @return resultType
     */
    public java.lang.String getResultType() {
        return resultType;
    }


    /**
     * Sets the resultType value for this ParamHTTP.
     * 
     * @param resultType
     */
    public void setResultType(java.lang.String resultType) {
        this.resultType = resultType;
    }


    /**
     * Gets the param value for this ParamHTTP.
     * 
     * @return param
     */
    public net.ivoa.www.xml.VODataService.v0_5.Param[] getParam() {
        return param;
    }


    /**
     * Sets the param value for this ParamHTTP.
     * 
     * @param param
     */
    public void setParam(net.ivoa.www.xml.VODataService.v0_5.Param[] param) {
        this.param = param;
    }

    public net.ivoa.www.xml.VODataService.v0_5.Param getParam(int i) {
        return this.param[i];
    }

    public void setParam(int i, net.ivoa.www.xml.VODataService.v0_5.Param value) {
        this.param[i] = value;
    }


    /**
     * Gets the qtype value for this ParamHTTP.
     * 
     * @return qtype
     */
    public net.ivoa.www.xml.VODataService.v0_5.HTTPQueryType getQtype() {
        return qtype;
    }


    /**
     * Sets the qtype value for this ParamHTTP.
     * 
     * @param qtype
     */
    public void setQtype(net.ivoa.www.xml.VODataService.v0_5.HTTPQueryType qtype) {
        this.qtype = qtype;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ParamHTTP)) return false;
        ParamHTTP other = (ParamHTTP) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.resultType==null && other.getResultType()==null) || 
             (this.resultType!=null &&
              this.resultType.equals(other.getResultType()))) &&
            ((this.param==null && other.getParam()==null) || 
             (this.param!=null &&
              java.util.Arrays.equals(this.param, other.getParam()))) &&
            ((this.qtype==null && other.getQtype()==null) || 
             (this.qtype!=null &&
              this.qtype.equals(other.getQtype())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = super.hashCode();
        if (getResultType() != null) {
            _hashCode += getResultType().hashCode();
        }
        if (getParam() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getParam());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getParam(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getQtype() != null) {
            _hashCode += getQtype().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ParamHTTP.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "ParamHTTP"));
        org.apache.axis.description.AttributeDesc attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("qtype");
        attrField.setXmlName(new javax.xml.namespace.QName("", "qtype"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "HTTPQueryType"));
        typeDesc.addFieldDesc(attrField);
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("resultType");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "resultType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("param");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "param"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "Param"));
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
