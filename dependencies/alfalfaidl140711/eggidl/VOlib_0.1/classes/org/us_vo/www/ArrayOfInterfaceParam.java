/**
 * ArrayOfInterfaceParam.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package org.us_vo.www;

public class ArrayOfInterfaceParam  implements java.io.Serializable {
    private org.us_vo.www.InterfaceParam[] interfaceParam;

    public ArrayOfInterfaceParam() {
    }


    /**
     * Gets the interfaceParam value for this ArrayOfInterfaceParam.
     * 
     * @return interfaceParam
     */
    public org.us_vo.www.InterfaceParam[] getInterfaceParam() {
        return interfaceParam;
    }


    /**
     * Sets the interfaceParam value for this ArrayOfInterfaceParam.
     * 
     * @param interfaceParam
     */
    public void setInterfaceParam(org.us_vo.www.InterfaceParam[] interfaceParam) {
        this.interfaceParam = interfaceParam;
    }

    public org.us_vo.www.InterfaceParam getInterfaceParam(int i) {
        return this.interfaceParam[i];
    }

    public void setInterfaceParam(int i, org.us_vo.www.InterfaceParam value) {
        this.interfaceParam[i] = value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ArrayOfInterfaceParam)) return false;
        ArrayOfInterfaceParam other = (ArrayOfInterfaceParam) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.interfaceParam==null && other.getInterfaceParam()==null) || 
             (this.interfaceParam!=null &&
              java.util.Arrays.equals(this.interfaceParam, other.getInterfaceParam())));
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
        if (getInterfaceParam() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getInterfaceParam());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getInterfaceParam(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ArrayOfInterfaceParam.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.us-vo.org", "ArrayOfInterfaceParam"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("interfaceParam");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "InterfaceParam"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.us-vo.org", "InterfaceParam"));
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
