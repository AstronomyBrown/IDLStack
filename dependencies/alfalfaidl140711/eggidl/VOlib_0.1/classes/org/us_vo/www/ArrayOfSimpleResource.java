/**
 * ArrayOfSimpleResource.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package org.us_vo.www;

public class ArrayOfSimpleResource  implements java.io.Serializable {
    private org.us_vo.www.SimpleResource[] simpleResource;

    public ArrayOfSimpleResource() {
    }


    /**
     * Gets the simpleResource value for this ArrayOfSimpleResource.
     * 
     * @return simpleResource
     */
    public org.us_vo.www.SimpleResource[] getSimpleResource() {
        return simpleResource;
    }


    /**
     * Sets the simpleResource value for this ArrayOfSimpleResource.
     * 
     * @param simpleResource
     */
    public void setSimpleResource(org.us_vo.www.SimpleResource[] simpleResource) {
        this.simpleResource = simpleResource;
    }

    public org.us_vo.www.SimpleResource getSimpleResource(int i) {
        return this.simpleResource[i];
    }

    public void setSimpleResource(int i, org.us_vo.www.SimpleResource value) {
        this.simpleResource[i] = value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ArrayOfSimpleResource)) return false;
        ArrayOfSimpleResource other = (ArrayOfSimpleResource) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.simpleResource==null && other.getSimpleResource()==null) || 
             (this.simpleResource!=null &&
              java.util.Arrays.equals(this.simpleResource, other.getSimpleResource())));
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
        if (getSimpleResource() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getSimpleResource());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getSimpleResource(), i);
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
        new org.apache.axis.description.TypeDesc(ArrayOfSimpleResource.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.us-vo.org", "ArrayOfSimpleResource"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("simpleResource");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "SimpleResource"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.us-vo.org", "SimpleResource"));
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
