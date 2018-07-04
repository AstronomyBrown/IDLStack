/**
 * ResourceInterface.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package org.us_vo.www;

public class ResourceInterface  implements java.io.Serializable {
    private int interfaceNum;
    private java.lang.String type;
    private java.lang.String qtype;
    private java.lang.String accessURL;
    private java.lang.String resultType;
    private org.us_vo.www.ArrayOfInterfaceParam interfaceParams;

    public ResourceInterface() {
    }


    /**
     * Gets the interfaceNum value for this ResourceInterface.
     * 
     * @return interfaceNum
     */
    public int getInterfaceNum() {
        return interfaceNum;
    }


    /**
     * Sets the interfaceNum value for this ResourceInterface.
     * 
     * @param interfaceNum
     */
    public void setInterfaceNum(int interfaceNum) {
        this.interfaceNum = interfaceNum;
    }


    /**
     * Gets the type value for this ResourceInterface.
     * 
     * @return type
     */
    public java.lang.String getType() {
        return type;
    }


    /**
     * Sets the type value for this ResourceInterface.
     * 
     * @param type
     */
    public void setType(java.lang.String type) {
        this.type = type;
    }


    /**
     * Gets the qtype value for this ResourceInterface.
     * 
     * @return qtype
     */
    public java.lang.String getQtype() {
        return qtype;
    }


    /**
     * Sets the qtype value for this ResourceInterface.
     * 
     * @param qtype
     */
    public void setQtype(java.lang.String qtype) {
        this.qtype = qtype;
    }


    /**
     * Gets the accessURL value for this ResourceInterface.
     * 
     * @return accessURL
     */
    public java.lang.String getAccessURL() {
        return accessURL;
    }


    /**
     * Sets the accessURL value for this ResourceInterface.
     * 
     * @param accessURL
     */
    public void setAccessURL(java.lang.String accessURL) {
        this.accessURL = accessURL;
    }


    /**
     * Gets the resultType value for this ResourceInterface.
     * 
     * @return resultType
     */
    public java.lang.String getResultType() {
        return resultType;
    }


    /**
     * Sets the resultType value for this ResourceInterface.
     * 
     * @param resultType
     */
    public void setResultType(java.lang.String resultType) {
        this.resultType = resultType;
    }


    /**
     * Gets the interfaceParams value for this ResourceInterface.
     * 
     * @return interfaceParams
     */
    public org.us_vo.www.ArrayOfInterfaceParam getInterfaceParams() {
        return interfaceParams;
    }


    /**
     * Sets the interfaceParams value for this ResourceInterface.
     * 
     * @param interfaceParams
     */
    public void setInterfaceParams(org.us_vo.www.ArrayOfInterfaceParam interfaceParams) {
        this.interfaceParams = interfaceParams;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ResourceInterface)) return false;
        ResourceInterface other = (ResourceInterface) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            this.interfaceNum == other.getInterfaceNum() &&
            ((this.type==null && other.getType()==null) || 
             (this.type!=null &&
              this.type.equals(other.getType()))) &&
            ((this.qtype==null && other.getQtype()==null) || 
             (this.qtype!=null &&
              this.qtype.equals(other.getQtype()))) &&
            ((this.accessURL==null && other.getAccessURL()==null) || 
             (this.accessURL!=null &&
              this.accessURL.equals(other.getAccessURL()))) &&
            ((this.resultType==null && other.getResultType()==null) || 
             (this.resultType!=null &&
              this.resultType.equals(other.getResultType()))) &&
            ((this.interfaceParams==null && other.getInterfaceParams()==null) || 
             (this.interfaceParams!=null &&
              this.interfaceParams.equals(other.getInterfaceParams())));
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
        _hashCode += getInterfaceNum();
        if (getType() != null) {
            _hashCode += getType().hashCode();
        }
        if (getQtype() != null) {
            _hashCode += getQtype().hashCode();
        }
        if (getAccessURL() != null) {
            _hashCode += getAccessURL().hashCode();
        }
        if (getResultType() != null) {
            _hashCode += getResultType().hashCode();
        }
        if (getInterfaceParams() != null) {
            _hashCode += getInterfaceParams().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ResourceInterface.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.us-vo.org", "ResourceInterface"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("interfaceNum");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "interfaceNum"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("type");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "type"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("qtype");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "qtype"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("accessURL");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "accessURL"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("resultType");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "resultType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("interfaceParams");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "interfaceParams"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.us-vo.org", "ArrayOfInterfaceParam"));
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
